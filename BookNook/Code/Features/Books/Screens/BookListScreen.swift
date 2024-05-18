//
//  BookListScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

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
    @State private var showingSearchBook = false
    @State private var selectedBook: Book?
    @Environment(\.modelContext) var context

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(books, id: \.id) { book in
                        BookCoverView(book: book)
                            .aspectRatio(1, contentMode: .fill)
                            .clipped()
                            .onTapGesture {
                                selectedBook = book
                            }
                            .contextMenu {
                                Button("Edit Book") {
                                    selectedBook = book
                                }
                                Button(role: .destructive) {
                                    deleteBook(book: book)
                                } label: {
                                    Text("Delete Book")
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Your bookshelf")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSearchBook = true
                    }) {
                        Label("Add Book", systemImage: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $showingSearchBook) {
                BookSearchScreen(showingSearchBook: $showingSearchBook)
            }
            .sheet(item: $selectedBook) { book in
                BookDetailView(book: book, sessions: sessions.filter { $0.book.id == book.id })
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

struct BookCoverView: View {
    var book: Book

    var body: some View {
        ZStack {
            if let coverImageUrl = book.coverImageUrl, let url = URL(string: coverImageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Color.gray.opacity(0.3)
                Text(book.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
            }
        }
        .frame(width: 150, height: 225)
        .cornerRadius(3)
        .shadow(radius: 4)
    }
}

struct BookDetailView: View {
    var book: Book
    var sessions: [ReadingSession]
    @Environment(\.modelContext) var context

    var body: some View {
        VStack {
            Text(book.title)
                .font(.largeTitle)
                .padding()

            List {
                ForEach(sessions, id: \.id) { session in
                    SessionView(session: session)
                        .contextMenu {
                            Button("Edit Session") {
                                // Handle edit session
                            }
                            Button(role: .destructive) {
                                deleteSession(session: session)
                            } label: {
                                Text("Delete Session")
                            }
                        }
                }
                .onDelete(perform: deleteSessions)
            }
            Text("Book Reading Time: \(formattedTime(totalBookReadingTime()))")

        }
        .navigationTitle("Sessions")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    // Handle back action
                }
            }
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
    private func totalBookReadingTime() -> TimeInterval {
        let bookSessions =  sessions.filter { $0.book.id == book.id }
        
        return bookSessions.reduce(0) { $0 + $1.duration }
    }
    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SessionView: View {
    @Bindable var session: ReadingSession

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
