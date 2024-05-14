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
    private let googleBooksAPI = GoogleBooksAPI()

    func searchBooks(query: String) {
        googleBooksAPI.searchBooks(query: query) { [weak self] result in
            switch result {
            case .success(let bookResponses):
                self?.books = bookResponses.map { response in
                    Book(
                        id: response.id,
                        title: response.volumeInfo.title,
                        author: response.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown",
                        bookDescription: response.volumeInfo.description,
                        publisher: response.volumeInfo.publisher,
                        publishedDate: response.volumeInfo.publishedDate,
                        pageCount: response.volumeInfo.pageCount,
                        categories: response.volumeInfo.categories,
                        coverImageUrl: response.volumeInfo.imageLinks?.thumbnail
                    )
                }
            case .failure(let error):
                print("Error fetching books: \(error.localizedDescription)")
            }
        }
    }
}

