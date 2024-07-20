//
//  BookListScreen2.swift
//  BookNook
//
//  Created by Riley Jenum on 30/05/24.
//

import SwiftUI
import SwiftData

struct BookListScreen2: View {
    
    var body: some View {
        VStack {
            BookshelfViewNEW(category: .currentlyReading)
            BookshelfViewNEW(category: .haveRead)
            BookshelfViewNEW(category: .willRead)
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)

    for i in 1..<3 {
        let book = Book(title: "Example Book \(i)", author: "", category: .currentlyReading)
        container.mainContext.insert(book)
    }
    
    for i in 1..<7 {
        let book = Book(title: "Example Book \(i)", author: "", category: .willRead)
        container.mainContext.insert(book)
    }
    for i in 1..<5 {
        let book = Book(title: "Example Book \(i)", author: "", category: .haveRead)
        container.mainContext.insert(book)
    }

    return BookListScreen2()
        .modelContainer(container)
}
