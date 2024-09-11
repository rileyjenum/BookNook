//
//  Book.swift
//  BookNook
//
//  Created by Riley Jenum on 12/05/24.
//
import Foundation
import SwiftData

enum BookCategory: String, CaseIterable, Codable {
    case currentlyReading, willRead, haveRead
}

@Model
class Book: Identifiable, Hashable {
    
    @Relationship(deleteRule: .cascade, inverse: \ReadingSession.book) var sessions: [ReadingSession]
    @Attribute(.unique) var id: String = UUID().uuidString
    
    var title: String
    var author: String
    var bookDescription: String?
    var publisher: String?
    var publishedDate: String?
    var pageCount: Int?
    var category: BookCategory
    var coverImageUrl: String?
    var pagesRead: Int?

    init(id: String = UUID().uuidString, title: String, author: String, bookDescription: String? = nil, publisher: String? = nil, publishedDate: String? = nil, pageCount: Int? = nil, category: BookCategory, coverImageUrl: String? = nil, pagesRead: Int? = 0, sessions: [ReadingSession] = []) {
        self.id = id
        self.title = title
        self.author = author
        self.bookDescription = bookDescription
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.pageCount = pageCount
        self.category = category
        self.coverImageUrl = coverImageUrl
        self.pagesRead = pagesRead
        self.sessions = sessions
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


