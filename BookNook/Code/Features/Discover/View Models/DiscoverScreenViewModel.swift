//
//  DiscoverScreenViewModel.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import SwiftUI
import Combine

class DiscoverScreenViewModel: ObservableObject {
    
    private let openLibraryAPI = OpenLibraryAPI()
    private let googleBooksAPI = GoogleBooksAPI()
    private let nytAPI = NewYorkTimesAPI()
    
    @Published var nytBestsellers: [String: [Book]] = [:]
    @Published var books: [Book] = []
    @Published var colorCache: [String: (Color, Color)] = [:]
    
    static let shared = DiscoverScreenViewModel()


    
    func searchBooks(query: String) {
        DispatchQueue.main.async {
            self.books.removeAll()
        }
        googleBooksAPI.searchBooks(title: query) { books in
            switch books {
            case .success(let books):
                for i in 0...(books?.count ?? 1) - 1 {
                    if let googleBookInfo = books?[i].volumeInfo {
                        let book = self.convertToBook(volumeInfo: googleBookInfo)
                        DispatchQueue.main.async {
                            self.books.append(book)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching books: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchBestsellers(for category: String, completion: @escaping () -> Void) {
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
                        completion()
                    }
                case .failure(let error):
                    print("Error fetching bestsellers: \(error.localizedDescription)")
                    completion()
                }
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
            //TODO: check if this is okay
            category: .currentlyReading,
            coverImageUrl: volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http", with: "https")
        )
    }
}
