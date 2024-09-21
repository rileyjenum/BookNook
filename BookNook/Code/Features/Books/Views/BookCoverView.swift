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
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 120, height: 180)
                .cornerRadius(10)
                .shadow(radius: 5)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 180)
                    .foregroundColor(.black)
                    .background(.gray)
                    .cornerRadius(10)
                    .shadow(radius: 5)
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
            coverImageUrl: nil
        )
        
        BookCoverView(book: mockBookWithoutImage)
            .modelContainer(container)


    }
}

