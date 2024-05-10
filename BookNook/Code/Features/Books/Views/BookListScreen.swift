//
//  BookListScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct BooksListScreen: View {
    // Query all reading sessions
    @Query(sort: [SortDescriptor(\ReadingSession.bookTitle)]) var sessions: [ReadingSession]

    // Computed property to group sessions by book title
    private var booksWithSessions: [(key: String, value: [ReadingSession])] {
        Dictionary(grouping: sessions, by: { $0.bookTitle })
            .sorted { $0.key < $1.key }
    }

    var body: some View {
        List {
            ForEach(booksWithSessions, id: \.key) { book, sessions in
                // Use DisclosureGroup to create an expandable view
                DisclosureGroup("\(book) (\(sessions.count) sessions)") {
                    ForEach(sessions, id: \.id) { session in
                        Text("Session on \(session.startTime, formatter: Formatter.item)")
                    }
                }
            }
        }
        .navigationTitle("Books List")
    }
}

