//
//  BookViewTest.swift
//  BookNook
//
//  Created by Riley Jenum on 12/09/24.
//

import SwiftUI
import SwiftData

struct BookshelfView: View {
    
    @Query(sort: [SortDescriptor(\Book.title)]) private var queriedBooks: [Book]
    
    let category: BookCategory
    
    @State var isBookDetailViewOpen: Bool = false
    
    @State var selectedBook: Book?
        
    @Binding var cachedBooks: [Book]
    
    @State private var isAnimating: Bool = false
    
    @Namespace private var bookAnimation
    
    var body: some View {
        VStack {
            Text(category.rawValue)
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .padding(.top, 50)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(cachedBooks) { book in
                        BookCoverView(book: book)
                            .frame(width: 200, height: 300)
                            .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 5)
                                    .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : (phase == .bottomTrailing ? 40 : -40)), axis: (x: 0, y: 1.0, z: 0))
                            }
                            .matchedGeometryEffect(id: book.id, in: bookAnimation, isSource: !isBookDetailViewOpen)
                            .onTapGesture {
                                guard !isAnimating else { return }
                                isAnimating = true
                                
                                withAnimation(.spring()) {
                                    selectedBook = book
                                    isBookDetailViewOpen = true
                                } completion: {
                                    isAnimating = false
                                }
                            }
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
                ZStack(alignment: .top) {
                    Color.white
                    
                    if let selectedBook = selectedBook {
                        VStack {
                            BookCoverView(book: selectedBook)
                                .frame(width: 200, height: 300)
                                .matchedGeometryEffect(id: selectedBook.id, in: bookAnimation, isSource: isBookDetailViewOpen)
                            Spacer()
                        }
                        .padding(.top, 100)
                    }
                }
                .onTapGesture {
                    guard !isAnimating else { return }
                    isAnimating = true
                    
                    withAnimation(.spring()) {
                        isBookDetailViewOpen = false
                        selectedBook = nil
                    } completion: {
                        isAnimating = false
                        
                    }
                }
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


    return BookshelfView(category: .currentlyReading, cachedBooks: .constant(mockBooks))
        .modelContainer(container)
}
