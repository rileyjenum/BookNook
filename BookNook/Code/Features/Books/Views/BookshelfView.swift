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
    
    @State var showBackOfBook: Bool = false
    
    @State var selectedBook: Book?
    
    @Binding var cachedBooks: [Book]
    
    @State private var isAnimating: Bool = false
    
    @State private var coverDegrees: Double = 0
    
    @State private var pageDegrees: Double = 0
    
    @Namespace private var bookAnimation
    
    var body: some View {
        VStack {
            Text(category.rawValue)
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .padding(.top, 50)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 35) {
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
                                        showBackOfBook = true
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            coverDegrees = -180
                                            pageDegrees = -10
                                        } completion: {
                                            isAnimating = false
                                        }
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
                                .blur(radius: phase.isIdentity ? 0 : 5)
                                .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : (phase == .bottomTrailing ? 40 : -40)), axis: (x: 0, y: 1.0, z: 0))
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
                GeometryReader { geo in
                    ZStack(alignment: .top) {
                        Color.white
                        if let book = selectedBook, let urlString = book.coverImageUrl, let url = URL(string: urlString) {
                            WebImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: geo.size.width, height:  geo.size.height)
                            .ignoresSafeArea(.all)
                            .blur(radius: 30.0)
                        }
                        ZStack {
                            Group {
                                if showBackOfBook {
                                    ZStack(alignment: .leading) {
                                        // Back of book
                                        Rectangle()
                                            .frame(width: 120, height: 180)
                                            .clipShape(
                                                .rect(
                                                    topLeadingRadius: 2,
                                                    bottomLeadingRadius: 2,
                                                    bottomTrailingRadius: 10,
                                                    topTrailingRadius: 10
                                                )
                                            )
                                            .foregroundColor(.gray)
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 0.0)
                                        // Page of book
                                        Rectangle()
                                            .frame(width: 110, height: 175)
                                            .foregroundColor(.white)
                                            .clipShape(
                                                .rect(
                                                    topLeadingRadius: 0,
                                                    bottomLeadingRadius: 0,
                                                    bottomTrailingRadius: 3,
                                                    topTrailingRadius: 3
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 0.0)
                                            .rotation3DEffect(.degrees(pageDegrees),axis: (x: 0.0, y: 1.0, z: 0.0), anchor: .leading, perspective: 0.3)
                                            .overlay {
                                                ZStack {
                                                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]), startPoint: .leading, endPoint: .trailing)
                                                }
                                                .rotation3DEffect(.degrees(pageDegrees),axis: (x: 0.0, y: 1.0, z: 0.0), anchor: .leading, perspective: 0.3)
                                            }
                                    }
                                }
                                if let selectedBookCover = selectedBook {
                                    ZStack {
                                        // Front side of the front book cover
                                        BookCoverView(book: selectedBookCover)
                                            .opacity(coverDegrees > -90 ? 1 : 0)
                                            .matchedGeometryEffect(id: selectedBookCover.id, in: bookAnimation, isSource: isBookDetailViewOpen)
                                        
                                        // Back side of the front book cover
                                        Rectangle()
                                            .frame(width: 120, height: 180)
                                            .clipShape(
                                                .rect(
                                                    topLeadingRadius: 2,
                                                    bottomLeadingRadius: 2,
                                                    bottomTrailingRadius: 10,
                                                    topTrailingRadius: 10
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 0.0)
                                            .foregroundColor(.gray)
                                            .opacity(coverDegrees <= -90 ? 1 : 0)
                                    }
                                    .rotation3DEffect(.degrees(coverDegrees),axis: (x: 0.0, y: 1.0, z: 0.0), anchor: .leading, perspective: 0.5)
                                    .onTapGesture {
                                        guard !isAnimating else { return }
                                        isAnimating = true
                                        withAnimation {
                                            coverDegrees = 0
                                            pageDegrees = 0
                                        } completion: {
                                            showBackOfBook = false
                                            withAnimation{
                                                isBookDetailViewOpen = false
                                                selectedBook = nil
                                            } completion: {
                                                isAnimating = false
                                            }
                                        }
                                    }
                                }
                            }
                            .offset(x: coverDegrees == -180 ? 50 : 0)
                        }
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
    
    
    return BookshelfView(category: .currentlyReading,selectedBook: mockBooks[0], cachedBooks: .constant(mockBooks))
        .modelContainer(container)
}
