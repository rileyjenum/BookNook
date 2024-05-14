//
//  Book.swift
//  BookNook
//
//  Created by Riley Jenum on 12/05/24.
//

import Foundation
import SwiftData

@Model
class Book: Identifiable, Hashable {
    @Attribute(.unique) var id: String = UUID().uuidString
    var title: String
    var author: String
    var bookDescription: String?
    var publisher: String?
    var publishedDate: String?
    var pageCount: Int?
    var categories: [String]?
    var coverImageUrl: String?

    @Relationship(deleteRule: .cascade, inverse: \ReadingSession.book) var sessions: [ReadingSession]

    init(id: String = UUID().uuidString, title: String, author: String, bookDescription: String? = nil, publisher: String? = nil, publishedDate: String? = nil, pageCount: Int? = nil, categories: [String]? = nil, coverImageUrl: String? = nil, sessions: [ReadingSession] = []) {
        self.id = id
        self.title = title
        self.author = author
        self.bookDescription = bookDescription
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.pageCount = pageCount
        self.categories = categories
        self.coverImageUrl = coverImageUrl
        self.sessions = sessions
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



