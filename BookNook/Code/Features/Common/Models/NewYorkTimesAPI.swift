//
//  NewYorkTimesAPI.swift
//  BookNook
//
//  Created by Riley Jenum on 19/05/24.
//

import Foundation

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

struct NewYorkTimesAPI {
    let apiKey = "w4GYGiEF6tt8KtImLMGd52DzoFJ0k1SG"
    let baseURL = "https://api.nytimes.com/svc/books/v3/lists/current/young-adult-hardcover.json"

    func fetchBestsellers(completion: @escaping (Result<[NYTBook], Error>) -> Void) {
        let urlString = "\(baseURL)?api-key=\(apiKey)"
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
