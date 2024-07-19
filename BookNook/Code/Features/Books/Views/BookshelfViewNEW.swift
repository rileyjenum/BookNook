//
//  TEST.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI
import SwiftData

struct BookshelfViewNEW: View {
    
    @Query(sort: [SortDescriptor(\Book.title)]) private var queriedBooks: [Book]
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    
    @Environment(\.modelContext) var context
    
    @StateObject private var viewModel = DiscoverScreenViewModel()

    @State private var draggedBook: Book?
    @State private var selectedBook: Book?
    @State private var books: [Book] = []

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(books, id: \.self) { book in
                        BookViewAnimated(book: book, selectedBook: $selectedBook)
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
                .frame(height: 600)
                .onChange(of: selectedBook) {
                    if let book = selectedBook {
                        withAnimation {
                            proxy.scrollTo(book, anchor: .center)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            books = queriedBooks
        }
        .onChange(of: queriedBooks) {
            books = queriedBooks
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
        // Swap Items
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

    for i in 1..<10 {
        let book = Book(title: "Example Book \(i)", author: "")
        container.mainContext.insert(book)
    }

    return BookshelfViewNEW()
        .modelContainer(container)
}


