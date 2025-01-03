//
//  BookCoverView.swift
//  BookNook
//
//  Created by Riley Jenum on 06/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ColorExtractingBookCoverView: View {
    
    var book: Book
    
    @Binding var spineColor: Color
    @Binding var textColor: Color
    
    @ObservedObject var viewModel: DiscoverScreenViewModel

    var body: some View {
        ZStack {
            if let coverImageUrl = book.coverImageUrl, let url = URL(string: coverImageUrl) {
                WebImage(url: url)
                    .onSuccess { image, data, cacheType in
                        DispatchQueue.main.async {
                            if let colors = image.getMainColors() {
                                let spineColor = Color(colors.0)
                                let textColor = Color(colors.1)
                                self.spineColor = spineColor
                                self.textColor = textColor
                                viewModel.colorCache[book.id] = (spineColor, textColor)
                            }
                        }
                    }
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



