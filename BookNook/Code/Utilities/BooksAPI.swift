//
//  BooksAPI.swift
//  BookNook
//
//  Created by Riley Jenum on 22/05/24.
//

import Foundation

// MARK: - NYT Bestseller structs

struct NYTBestsellerResponse: Codable {
    let results: NYTResults
}

struct NYTResults: Codable {
    let books: [NYTBook]
}

struct NYTBook: Codable {
    let title: String
    let author: String
}

// MARK: - Open Library structs

struct OpenLibraryResponse: Codable {
    let docs: [OpenLibraryBookResponse]
}

struct OpenLibraryBookResponse: Codable {
    let key: String
    let title: String
    let author_name: [String]?
}
// MARK: - Google Books structs

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

// MARK: - Open Library API

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
                print(response.docs)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - Google Books API

struct GoogleBooksAPI {
    let apiKey = "AIzaSyAJXzZqEnc0PV685KeLWv4ndyl4pax4NUo"
    let baseURL = "https://www.googleapis.com/books/v1/volumes"

    func searchBookByTitleAndAuthor(title: String, author: String?, completion: @escaping (Result<GoogleBooksBookResponse?, Error>) -> Void) {
        var query = "intitle:\(title)"
        if let author = author {
            query += "+inauthor:\(author)"
        }
        let urlString = "\(baseURL)?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=\(apiKey)&maxResults=1"
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
                completion(.success(response.items?.first))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func searchBooks(title: String, completion: @escaping (Result<[GoogleBooksBookResponse]?, Error>) -> Void) {

        let urlString = "\(baseURL)?q=\(title)&key=\(apiKey)&maxResults=20"
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
                completion(.success(response.items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - NYT Bestsellers API

struct NewYorkTimesAPI {
    let apiKey = "w4GYGiEF6tt8KtImLMGd52DzoFJ0k1SG"
    let baseURL = "https://api.nytimes.com/svc/books/v3/lists/current/"

    func fetchBestsellers(for category: String, completion: @escaping (Result<[NYTBook], Error>) -> Void) {
        let urlString = "\(baseURL)\(category).json?api-key=\(apiKey)"
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
                let response = try JSONDecoder().decode(NYTBestsellerResponse.self, from: data)
                completion(.success(response.results.books))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
