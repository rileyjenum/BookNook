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
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    @State private var showingAddBook = false
    @Environment(\.modelContext) var context

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.id) { book in
                    BookRow(book: book, sessions: sessions.filter { $0.book.id == book.id })
                }
                .onDelete(perform: deleteBooks)
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

    func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            let book = books[index]
            deleteBook(book: book)
        }
    }

    func deleteBook(book: Book) {
        // First, delete all associated sessions
        for session in book.sessions {
            context.delete(session)
        }

        // Now delete the book
        context.delete(book)

        // Save context
        do {
            try context.save()
        } catch {
            print("Failed to delete book and its sessions: \(error.localizedDescription)")
        }
    }
}

struct BookRow: View {
    var book: Book
    var sessions: [ReadingSession]
    @Environment(\.modelContext) var context

    var body: some View {
        DisclosureGroup("\(book.title) (\(sessions.count) sessions)") {
            ForEach(sessions, id: \.id) { session in
                SessionView(session: session)
            }
            .onDelete(perform: deleteSessions)
        }
    }

    func deleteSessions(at offsets: IndexSet) {
        for index in offsets {
            let session = sessions[index]
            deleteSession(session: session)
        }
    }

    func deleteSession(session: ReadingSession) {
        context.delete(session)
        do {
            try context.save()
        } catch {
            print("Failed to delete session: \(error.localizedDescription)")
        }
    }
}

struct SessionView: View {
    var session: ReadingSession

    var body: some View {
        VStack(alignment: .leading) {
            Text("Session on \(session.startTime, formatter: Formatter.item)")
            Text("Duration: \(session.duration) seconds")
            Text("Notes: \(session.notes)")
        }
        .padding()
    }
}

struct Formatter {
    static let item: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

struct BooksListScreen_Previews: PreviewProvider {
    static var previews: some View {
        BooksListScreen()
    }
}
