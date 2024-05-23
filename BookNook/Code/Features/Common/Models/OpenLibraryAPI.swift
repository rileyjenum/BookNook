//
//  OpenLibraryAPI.swift
//  BookNook
//
//  Created by Riley Jenum on 19/05/24.
//

//import Foundation
//
//struct OpenLibraryResponse: Codable {
//    let docs: [BookResponse]
//}
//
//struct BookResponse: Codable {
//    let key: String
//    let title: String
//    let author_name: [String]?
//    let first_publish_year: Int?
//    let publisher: [String]?
//    let number_of_pages_median: Int?
//    let subject: [String]?
//    let cover_i: Int?
//}
//
//struct OpenLibraryAPI {
//    let baseURL = "https://openlibrary.org/search.json"
//
//    func searchBooks(query: String, completion: @escaping (Result<[BookResponse], Error>) -> Void) {
//        let urlString = "\(baseURL)?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=15"
//        print(urlString)
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
//                completion(.success(response.docs))
//                print(response.docs.count)
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
