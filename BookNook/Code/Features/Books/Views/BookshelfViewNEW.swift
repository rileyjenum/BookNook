//
//  TEST.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI
import SwiftData

struct BookshelfViewNEW: View {
    var category: BookCategory
    var height: CGFloat
    
    @Query(sort: [SortDescriptor(\Book.title)]) private var queriedBooks: [Book]
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    
    @Environment(\.modelContext) var context
    
    @StateObject private var viewModel = DiscoverScreenViewModel()

    @State private var draggedBook: Book?
    @State private var books: [Book] = []
    @State private var bookDimensions: [Book: (height: CGFloat, width: CGFloat)] = [:]
    
    @Binding var selectedBook: Book?


    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(books, id: \.self) { book in
                        if let dimensions = bookDimensions[book] {
                            BookViewAnimated(book: book, selectedBook: $selectedBook, bookHeight: .constant(dimensions.height), bookWidth: .constant(dimensions.width))
                                .id(book)
                                .onDrag {
                                    self.draggedBook = book
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text],
                                        delegate: DropViewDelegate(destinationItem: book, books: $books, draggedItem: $draggedBook)
                                )
                                .zIndex((draggedBook == book) || (selectedBook == book) ? 1 : 0)
                        }
                    }
                }
                .frame(height: height)
                .opacity(height == 0 ? 0 : 1)
                .animation(.easeInOut(duration: 0.5), value: height)
                .onChange(of: selectedBook) {
                    if let book = selectedBook {
                        withAnimation {
                            proxy.scrollTo(book, anchor: .center)
                        }
                    }
                }
            }
        }
        .onAppear {
            filterBooksByCategory()
            generateRandomDimensions()
        }
        .onChange(of: queriedBooks) {
            filterBooksByCategory()
            generateRandomDimensions()
        }
    }
    
    private func filterBooksByCategory() {
        books = queriedBooks.filter { $0.category == category }
    }
    
    // Generate random dimensions for each book
    private func generateRandomDimensions() {
        for book in books {
            bookDimensions[book] = (height: CGFloat.random(in: 200...250), width: CGFloat.random(in: 30...50))
        }
    }
}

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: Book
    @Binding var books: [Book]
    @Binding var draggedItem: Book?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedItem {
            let fromIndex = books.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = books.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.books.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)

    for i in 1..<25 {
        let book = Book(title: "Example Book \(i)", author: "", category: .currentlyReading)
        container.mainContext.insert(book)
    }
    @State var selectedBook: Book? = Book(title: "", author: "")


    return BookshelfViewNEW(category: .currentlyReading, height: 400, selectedBook: $selectedBook)
        .modelContainer(container)
}
