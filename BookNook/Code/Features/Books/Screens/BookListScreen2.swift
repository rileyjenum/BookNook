//
//  BookListScreen2.swift
//  BookNook
//
//  Created by Riley Jenum on 15/09/24.
//

import SwiftUI
import SwiftData

struct BookListScreen2: View {
    let categories: [BookCategory] = [.currentlyReading, .haveRead, .willRead]
    
    @Binding var currentlyReadingCachedBooks: [Book]
    @Binding var haveReadCachedBooks: [Book]
    @Binding var willReadCachedBooks: [Book]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(categories, id: \.self) { category in
                        BookshelfView2(category: category, cachedBooks: bindingForCategory(category))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.75)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
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

    return BookListScreen2(currentlyReadingCachedBooks: .constant([]), haveReadCachedBooks: .constant([]), willReadCachedBooks: .constant([]))
        .modelContainer(container)
}
