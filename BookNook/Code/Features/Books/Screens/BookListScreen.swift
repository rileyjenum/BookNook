//
//  BookListScreen2.swift
//  BookNook
//
//  Created by Riley Jenum on 15/09/24.
//

import SwiftUI
import SwiftData

struct BookListScreen: View {
    let categories: [BookCategory] = [.currentlyReading, .haveRead, .willRead]
    
    @Binding var currentlyReadingCachedBooks: [Book]
    @Binding var haveReadCachedBooks: [Book]
    @Binding var willReadCachedBooks: [Book]
    
    var body: some View {
        GeometryReader { geo in
            BookshelfView(category: .currentlyReading, cachedBooks: bindingForCategory(.currentlyReading))
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func bindingForCategory(_ category: BookCategory) -> Binding<[Book]> {
        switch category {
        case .currentlyReading:
            return $currentlyReadingCachedBooks
        case .haveRead:
            return $haveReadCachedBooks
        case .willRead:
            return $willReadCachedBooks
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)

    for i in 1..<5 {
        let bookCurrentlyReading = Book(title: "Currently Reading Book \(i)", author: "", category: .currentlyReading)
        container.mainContext.insert(bookCurrentlyReading)
        let bookWillRead = Book(title: "Will Read Book \(i)", author: "", category: .willRead)
        container.mainContext.insert(bookWillRead)
        let bookHaveRead = Book(title: "Have Read Book \(i)", author: "", category: .haveRead)
        container.mainContext.insert(bookHaveRead)
    }

    return BookListScreen(currentlyReadingCachedBooks: .constant([]), haveReadCachedBooks: .constant([]), willReadCachedBooks: .constant([]))
        .modelContainer(container)
}
