//
//  BookCoverView.swift
//  BookNook
//
//  Created by Riley Jenum on 06/07/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct BookCoverView: View {
    
    var book: Book

    var body: some View {
        ZStack {
            if let coverImageUrl = book.coverImageUrl, let url = URL(string: coverImageUrl) {
                WebImage(url: url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 225)
            } else {
                Color.gray.opacity(0.3)
                Text(book.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
            }
        }
        .frame(width: 150, height: 225)
        .cornerRadius(3)
        .shadow(radius: 4)
    }
}
