//
//  BookViewModel.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import SwiftUI
import Combine

class BookViewModel: ObservableObject {
    
    private let openLibraryAPI = OpenLibraryAPI()
    private let googleBooksAPI = GoogleBooksAPI()
    private let nytAPI = NewYorkTimesAPI()
    
    @Published var nytBestsellers: [String: [Book]] = [:]
    @Published var books: [Book] = []
    @Published var colorCache: [String: (Color, Color)] = [:]


    
    func searchBooks(query: String) {
        openLibraryAPI.searchBooks(query: query) { [weak self] result in
            switch result {
            case .success(let openLibraryBooks):
                self?.fetchBookDetailsFromGoogleBooks(openLibraryBooks: openLibraryBooks) { detailedBooks in
                    DispatchQueue.main.async {
                        self?.books = detailedBooks
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching books: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchBestsellers(for category: String) {
        nytAPI.fetchBestsellers(for: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nytBooks):
                    let group = DispatchGroup()
                    var detailedBooks: [Book] = []
                    
                    for nytBook in nytBooks {
                        group.enter()
                        self?.googleBooksAPI.searchBookByTitleAndAuthor(title: nytBook.title, author: nytBook.author) { googleBooksResult in
                            switch googleBooksResult {
                            case .success(let googleBook):
                                if let googleBookInfo = googleBook?.volumeInfo {
                                    let book = self?.convertToBook(volumeInfo: googleBookInfo)
                                    if let book = book {
                                        detailedBooks.append(book)
                                    }
                                }
                            case .failure(let error):
                                print("Error fetching Google Book: \(error)")
                            }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self?.nytBestsellers[category] = detailedBooks
                    }
                case .failure(let error):
                    print("Error fetching bestsellers: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchBookDetailsFromGoogleBooks(openLibraryBooks: [OpenLibraryBookResponse], completion: @escaping ([Book]) -> Void) {
        let group = DispatchGroup()
        var detailedBooks: [Book?] = Array(repeating: nil, count: openLibraryBooks.count)
        var errors: [Error] = []
        
        for (index, openLibraryBook) in openLibraryBooks.enumerated() {
            group.enter()
            
            googleBooksAPI.searchBookByTitleAndAuthor(title: openLibraryBook.title, author: openLibraryBook.author_name?.first) { googleBooksResult in
                defer { group.leave() }
                
                switch googleBooksResult {
                case .success(let googleBook):
                    if let googleBookInfo = googleBook?.volumeInfo {
                        let book = self.convertToBook(volumeInfo: googleBookInfo)
                        detailedBooks[index] = book
                    }
                case .failure(let error):
                    errors.append(error)
                }
            }
        }
        
        group.notify(queue: .main) {
            let filteredBooks = detailedBooks.compactMap { $0 } // Remove nil values
            if errors.isEmpty {
                completion(filteredBooks)
            } else {
                print("Some errors occurred: \(errors)")
                completion(filteredBooks)
            }
        }
    }
    
    
    private func convertToBook(volumeInfo: VolumeInfo) -> Book {
        return Book(
            title: volumeInfo.title,
            author: volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author",
            bookDescription: volumeInfo.description,
            publisher: volumeInfo.publisher,
            publishedDate: volumeInfo.publishedDate,
            pageCount: volumeInfo.pageCount,
            categories: volumeInfo.categories,
            coverImageUrl: volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http", with: "https")
        )
    }
}
