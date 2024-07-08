//
//  BookListScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct BooksListScreen: View {
    
    @StateObject private var viewModel = DiscoverScreenViewModel()
    
    @State private var addNewBookShowing: Bool = false
    @State private var selectedBook: Book?
    @State private var isEditingBook = false
    
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]

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
                        NavigationLink(destination: BookDetailView(book: book, sessions: sessions.filter { $0.book.id == book.id })) {
                            BookCoverView(book: book)
                                .aspectRatio(1, contentMode: .fill)
                                .clipped()
                                .contextMenu {
                                    Button("Edit Book") {
                                        selectedBook = book
                                        isEditingBook = true
                                    }
                                    Button(role: .destructive) {
                                        deleteBook(book: book)
                                    } label: {
                                        Text("Delete Book")
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Your bookshelf")
            .sheet(isPresented: $isEditingBook) {
                if let book = selectedBook {
                    UpdateBookView(book: book)
                }
            }
            .sheet(isPresented: $addNewBookShowing) {
                NewBookView()
            }
            .toolbar {
                Button {
                    addNewBookShowing = true
                } label: {
                    Image(systemName: "plus")
                }
                
                
                
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
