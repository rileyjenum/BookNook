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
    // Query all books and include related sessions
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.id) { book in
                    // Use DisclosureGroup to create an expandable view
                    DisclosureGroup("\(book.title) (\(book.sessions.count) sessions)") {
                        ForEach(book.sessions, id: \.id) { session in
                            Text("Session on \(session.startTime, formatter: Formatter.item)")
                        }
                    }
                }
            }
            .navigationTitle("Books List")
        }
    }
}


struct BookListScreen_Previews: PreviewProvider {
    static var previews: some View {
        BooksListScreen()
    }
}

