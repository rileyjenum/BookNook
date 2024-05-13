//
//  BookListScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import SwiftData

struct BooksListScreen: View {
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    @State private var showingAddBook = false

    var body: some View {
        NavigationView {
            List(books, id: \.id) { book in
                BookRow(book: book)
            }
            .navigationTitle("Books List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBook = true
                    }) {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBook) {
                NewBookView()
            }
        }
    }
}

struct BookRow: View {
    var book: Book

    var body: some View {
        DisclosureGroup("\(book.title) (\(book.sessions.count) sessions)") {
            ForEach(book.sessions, id: \.id) { session in
                SessionView(session: session)
            }
        }
    }
}

struct SessionView: View {
    var session: ReadingSession

    var body: some View {
        Text("Session on \(session.startTime, formatter: Formatter.item)")
    }
}

struct Formatter {
    static let item: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

struct BooksListScreen_Previews: PreviewProvider {
    static var previews: some View {
        BooksListScreen()
    }
}
