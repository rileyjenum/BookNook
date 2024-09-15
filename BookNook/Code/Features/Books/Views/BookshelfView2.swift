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
    
    

    var body: some View {
        VStack {
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
                                    .scaleEffect(phase.isIdentity ? 1.3 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 5)
                                    .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : (phase == .bottomTrailing ? 40 : -40)), axis: (x: 0, y: 1.0, z: 0))
                            }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, UIScreen.main.bounds.width / 2 - 100)
            }
            .scrollTargetBehavior(.viewAligned)
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
