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

    @Relationship(deleteRule: .cascade, inverse: \ReadingSession.book) var sessions: [ReadingSession]

    init(id: String = UUID().uuidString, title: String, author: String, sessions: [ReadingSession] = []) {
        self.id = id
        self.title = title
        self.author = author
        self.sessions = sessions
    }
}
