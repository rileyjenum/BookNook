//
//  BookCoverView.swift
//  BookNook
//
//  Created by Riley Jenum on 06/07/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import SwiftData

struct BookCoverView: View {
    var book: Book
    
    var body: some View {
        VStack {
            if let urlString = book.coverImageUrl, let url = URL(string: urlString) {
                WebImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.gray)
                }
                .indicator(.activity)
                .clipShape(
                    .rect(
                        topLeadingRadius: 2,
                        bottomLeadingRadius: 2,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 10
                    )
                )
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .shadow(color: .black.opacity(0.5), radius: 5, x: 10, y: 0.0)
                .frame(width: 120, height: 180)
            } else {
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
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 10, y: 0.0)

            }
        }
    }
}


struct BookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Book.self, configurations: config)
        let mockBookWithoutImage = Book(
            title: "Sample Book",
            author: "Author Name",
            category: .currentlyReading,
            coverImageUrl: "https://books.google.com/books/content?id=54BEAAAACAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        )
        
        BookCoverView(book: mockBookWithoutImage)
            .modelContainer(container)


    }
}

