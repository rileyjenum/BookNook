//
//  BookListScreen2.swift
//  BookNook
//
//  Created by Riley Jenum on 30/05/24.
//

import SwiftUI
import SwiftData

struct BookListScreen2: View {
    
    @State private var selectedBook: Book?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                BookshelfViewNEW(category: .currentlyReading, height: bookshelfHeight(for: .currentlyReading, in: geometry), selectedBook: $selectedBook)
                BookshelfViewNEW(category: .haveRead, height: bookshelfHeight(for: .haveRead, in: geometry), selectedBook: $selectedBook)
                BookshelfViewNEW(category: .willRead, height: bookshelfHeight(for: .willRead, in: geometry), selectedBook: $selectedBook)
            }
        }
    }

    private func bookshelfHeight(for category: BookCategory, in geometry: GeometryProxy) -> CGFloat {
        guard let selectedBook = selectedBook else {
            return geometry.size.height / 3
        }
        return selectedBook.category == category ? geometry.size.height : 0
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)

    for i in 1..<20 {
        let book = Book(title: "Example Book \(i)", author: "", category: .currentlyReading)
        container.mainContext.insert(book)
    }
    
    for i in 1..<20 {
        let book = Book(title: "Example Book \(i)", author: "", category: .willRead)
        container.mainContext.insert(book)
    }
    for i in 1..<20 {
        let book = Book(title: "Example Book \(i)", author: "", category: .haveRead)
        container.mainContext.insert(book)
    }

    return BookListScreen2()
        .modelContainer(container)
}
