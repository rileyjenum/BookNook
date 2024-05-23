//
//  BookViewModel.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import SwiftUI
import Combine

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    private let openLibraryAPI = OpenLibraryAPI()
    private let googleBooksAPI = GoogleBooksAPI()
    
    func searchBooks(query: String) {
        openLibraryAPI.searchBooks(query: query) { [weak self] result in
            switch result {
            case .success(let openLibraryBooks):
                let group = DispatchGroup()
                var detailedBooks: [Book] = []
                var errors: [Error] = []
                
                for openLibraryBook in openLibraryBooks {
                    group.enter()
                    let googleBooksQuery = self?.constructGoogleBooksQuery(from: openLibraryBook) ?? ""
                    
                    self?.googleBooksAPI.searchBooks(query: googleBooksQuery) { googleBooksResult in
                        defer { group.leave() }
                        
                        switch googleBooksResult {
                        case .success(let googleBooksBooks):
                            if let googleBookInfo = googleBooksBooks.first?.volumeInfo {
                                let book = self?.convertToBook(volumeInfo: googleBookInfo)
                                if let book = book {
                                    detailedBooks.append(book)
                                }
                            }
                        case .failure(let error):
                            errors.append(error)
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    DispatchQueue.main.async {
                        if errors.isEmpty {
                            self?.books = detailedBooks
                        } else {
                            print("Some errors occurred: \(errors)")
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
    
    private func constructGoogleBooksQuery(from openLibraryBook: OpenLibraryBookResponse) -> String {
        var queryComponents: [String] = []
        
        if let title = openLibraryBook.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            queryComponents.append("intitle:\(title)")
        }
        if let author = openLibraryBook.author_name?.first?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            queryComponents.append("inauthor:\(author)")
        }
        
        return queryComponents.joined(separator: "+")
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
            coverImageUrl: volumeInfo.imageLinks?.thumbnail
        )
    }
}
