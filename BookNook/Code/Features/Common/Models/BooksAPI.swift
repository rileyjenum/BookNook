//
//  BooksAPI.swift
//  BookNook
//
//  Created by Riley Jenum on 22/05/24.
//

import Foundation

struct OpenLibraryResponse: Codable {
    let docs: [OpenLibraryBookResponse]
}

struct OpenLibraryBookResponse: Codable {
    let key: String
    let title: String
    let author_name: [String]?
}

struct VolumeResponse: Codable {
    let items: [GoogleBooksBookResponse]?
}

struct GoogleBooksBookResponse: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let publisher: String?
    let publishedDate: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let averageRating: Double?
    let ratingsCount: Int?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct OpenLibraryAPI {
    let baseURL = "https://openlibrary.org/search.json"

    func searchBooks(query: String, completion: @escaping (Result<[OpenLibraryBookResponse], Error>) -> Void) {
        let urlString = "\(baseURL)?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=15"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
                completion(.success(response.docs))
                print(response.docs.count)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct GoogleBooksAPI {
    let apiKey = "AIzaSyAJXzZqEnc0PV685KeLWv4ndyl4pax4NUo"
    let baseURL = "https://www.googleapis.com/books/v1/volumes"

    func searchBooks(query: String, sort: String = "relevance", completion: @escaping (Result<[GoogleBooksBookResponse], Error>) -> Void) {
        let urlString = "\(baseURL)?q=\(query)&orderBy=\(sort)&key=\(apiKey)&maxResults=1&fields=items(id,volumeInfo(title,authors,description,publisher,publishedDate,pageCount,categories,imageLinks,averageRating,ratingsCount))"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(VolumeResponse.self, from: data)
                completion(.success(response.items ?? []))
                print(response.items?.count)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
