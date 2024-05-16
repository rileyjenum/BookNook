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

    func searchBooks(query: String, language: String, sort: String) {
        googleBooksAPI.searchBooks(query: query, language: language, sort: sort) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookResponses):
                    self?.books = bookResponses.map { response in
                        // Ensure HTTPS URL
                        let coverImageUrl = response.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
                        return Book(
                            id: response.id,
                            title: response.volumeInfo.title,
                            author: response.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown",
                            bookDescription: response.volumeInfo.description,
                            publisher: response.volumeInfo.publisher,
                            publishedDate: response.volumeInfo.publishedDate,
                            pageCount: response.volumeInfo.pageCount,
                            categories: response.volumeInfo.categories,
                            coverImageUrl: coverImageUrl
                        )
                    }
                case .failure(let error):
                    print("Error fetching books: \(error.localizedDescription)")
                }
            }
        }
    }
}



