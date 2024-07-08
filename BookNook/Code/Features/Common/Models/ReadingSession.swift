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
    var book: Book
    var notes: String
    var pagesRead: Int

    init(id: String = UUID().uuidString, startTime: Date, duration: TimeInterval, book: Book, notes: String, pagesRead: Int) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.book = book
        self.notes = notes
        self.pagesRead = pagesRead
    }
}
