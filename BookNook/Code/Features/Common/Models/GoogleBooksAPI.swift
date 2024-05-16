//
//  GoogleBooksAPI.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import Foundation

struct VolumeResponse: Codable {
    let items: [BookResponse]?
}

struct BookResponse: Codable {
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
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct GoogleBooksAPI {
    let apiKey = "AIzaSyAJXzZqEnc0PV685KeLWv4ndyl4pax4NUo"
    let baseURL = "https://www.googleapis.com/books/v1/volumes"

    func searchBooks(query: String,language: String,sort: String, completion: @escaping (Result<[BookResponse], Error>) -> Void) {
        let urlString = "\(baseURL)?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&langRestrict=\(language)&orderBy=\(sort)&key=\(apiKey)"
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
