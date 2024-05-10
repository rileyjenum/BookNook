//
//  ReadingSession.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import Foundation
import SwiftData

@Model
class ReadingSession: Identifiable, Hashable {
    @Attribute(.unique) var id: String = UUID().uuidString
    var startTime: Date
    var duration: TimeInterval
    var bookTitle: String
    var author: String
    var notes: String
    
    init(id: String, startTime: Date, duration: TimeInterval, bookTitle: String, author: String, notes: String) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.bookTitle = bookTitle
        self.author = author
        self.notes = notes
    }
}
