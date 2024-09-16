//
//  BookViewTest.swift
//  BookNook
//
//  Created by Riley Jenum on 12/09/24.
//

import SwiftUI
import SwiftData

struct BookshelfView2: View {
    
    @Query(sort: [SortDescriptor(\Book.title)]) private var queriedBooks: [Book]
    
    let category: BookCategory
    
    @State var isBookDetailViewOpen: Bool = false
    
    @State var selectedBook: Book?
    
    @State private var bookRotation: Double = 0
    
    @Namespace private var bookAnimation
    
    var body: some View {
        VStack {
            if !isBookDetailViewOpen {
                Text(category.rawValue)
                    .font(.system(.title2, design: .monospaced, weight: .bold))
                    .padding(.top, 50)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(queriedBooks) { book in
                            BookCoverView(book: book)
                                .frame(width: 200, height: 300)
                                .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.75)
                                        .blur(radius: phase.isIdentity ? 0 : 5)
                                        .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : (phase == .bottomTrailing ? 40 : -40)), axis: (x: 0, y: 1.0, z: 0))
                                }
                                .matchedGeometryEffect(id: book.id, in: bookAnimation)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedBook = book
                                        isBookDetailViewOpen.toggle()
                                        bookRotation = 360
                                    }
                                }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, UIScreen.main.bounds.width / 2 - 100)
                }
                .scrollTargetBehavior(.viewAligned)
            } else {
                ZStack(alignment: .top) {
                    Color.white
                    
                    if let selectedBook = selectedBook {
                        VStack(spacing: 20) {
                            BookCoverView(book: selectedBook)
                                .frame(width: 200, height: 300)
                                .matchedGeometryEffect(id: selectedBook.id, in: bookAnimation)
                                .rotation3DEffect(Angle(degrees: bookRotation), axis: (x: 0, y: 1.0, z: 0))
                                .onAppear {
                                    withAnimation(.bouncy(duration: 0.8)) {
                                        bookRotation = 0
                                    }
                                }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        isBookDetailViewOpen.toggle()
                        selectedBook = nil

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
    @State var selectedBook: Book? = Book(title: "", author: "", category: .haveRead)


    return BookshelfView2(category: .currentlyReading)
        .modelContainer(container)
}
