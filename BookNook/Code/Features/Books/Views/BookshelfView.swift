//
//  BookViewTest.swift
//  BookNook
//
//  Created by Riley Jenum on 12/09/24.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct BookshelfView: View {
    
    @Query(sort: [SortDescriptor(\Book.title)]) private var queriedBooks: [Book]
    
    let category: BookCategory
    
    @State var isBookDetailViewOpen: Bool = false
        
    @State var selectedBook: Book?
    
    @Binding var cachedBooks: [Book]
    
    @State private var isAnimating: Bool = false
    
    @State private var isBookOpen: Bool = false
    
    @State private var isLibraryCardVisible: Bool = false
    
    @Namespace private var bookAnimation
    
    var body: some View {
        VStack {
            Text(category.rawValue)
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .padding(.top, 50)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(cachedBooks) { book in
                        VStack {
                            BookCoverView(book: book)
                                .matchedGeometryEffect(id: book.id, in: bookAnimation, isSource: !isBookDetailViewOpen)
                                .onTapGesture {
                                    guard !isAnimating else { return }
                                    isAnimating = true
                                    
                                    withAnimation {
                                        selectedBook = book
                                        isBookDetailViewOpen = true
                                    } completion: {
                                        isAnimating = false
                                    }
                                }
                            Text(book.title)
                                .font(.custom("Baskerville Bold", size: 25))
                                .padding(.top, 10)
                                .multilineTextAlignment(.center)
                            Text(book.author)
                                .font(.custom("Baskerville Light", size: 20))
                                .padding(.top, 3)
                                .multilineTextAlignment(.center)
                        }
                        .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.75)
                                .blur(radius: phase.isIdentity ? 0 : 3)
                        }
                        .frame(width: 200, height: 300)
                        
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, UIScreen.main.bounds.width / 2 - 100)
            }
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                if cachedBooks.isEmpty {
                    cachedBooks = queriedBooks.filter { $0.category == category }
                }
            }
        }
        .overlay {
            if isBookDetailViewOpen {

            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
    let mockBooks = [
        Book(title: "Sample Book 1", author: "Author 1", category: .currentlyReading),
        Book(title: "Sample Book 2", author: "Author 2", category: .currentlyReading),
        Book(title: "Sample Book 3", author: "Author 3", category: .currentlyReading),
        Book(title: "Sample Book 4", author: "Author 4", category: .currentlyReading),
        Book(title: "Sample Book 5", author: "Author 5", category: .currentlyReading),
        Book(title: "Sample Book 6", author: "Author 6", category: .currentlyReading)
    ]
    
    
    return BookshelfView(category: .currentlyReading,selectedBook: mockBooks[0], cachedBooks: .constant(mockBooks))
        .modelContainer(container)
}
