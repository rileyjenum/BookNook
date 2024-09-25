//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI


struct BookCoverView2: View {
    @Binding var isBookOpen: Bool
    @State private var animationDone: Bool = false
    
    var book: Book?
    let totalItems = 8
    let minRotation: Double = -180
    let maxRotation: Double = 0
    let colors = [
        Color(red: 0.75, green: 0.72, blue: 0.65),
        Color(red: 0.95, green: 0.92, blue: 0.85)
    ]
    
    let coverColors = [
        Color(red: 0.15, green: 0.22, blue: 0.35),
        Color(red: 0.15, green: 0.12, blue: 0.45)
    ]
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<totalItems, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors:  colors), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 120 , height: 180)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 2,
                                    bottomLeadingRadius: 2,
                                    bottomTrailingRadius: 10,
                                    topTrailingRadius: 10
                                )
                            )
                        Text(Utils.bookText)
                            .font(.system(size: 5))
                            .padding([.leading, .trailing], 10)
                            .multilineTextAlignment(.center)

                    }
                    .frame(width: 120 , height: 180)

                    .rotation3DEffect(
                        Angle(degrees: isBookOpen ? calculateRotation(for: index) : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.3
                    )
                    .zIndex(calculateZIndex(for: index))
                    
                }
                if let selectedBook = book {
                    WebImage(url: URL(string: selectedBook.coverImageUrl ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 10, y: 0.0)
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
                    .opacity(isBookOpen ? 0 : 1)
                    .rotation3DEffect(
                        Angle(degrees: isBookOpen ? -180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.3
                    )
                    .zIndex(animationDone ? 0 : 8)
                    .frame(width: 120, height: 180)
                }
            }
        }
    }
    func calculateRotation(for index: Int) -> Double {
        var rotation = minRotation + (maxRotation - minRotation) * (Double(index) / Double(totalItems - 1))
        if index == 4 || index == 1 {
            rotation += 8
        } else if index == 3 || index == 6 {
            rotation -= 8
        }
        return rotation
    }
    
    func calculateZIndex(for index: Int) -> Double {
        if index < 4 {
            return Double(index)
        } else {
            return Double(10 - index)
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
    
    return BookCoverView2(isBookOpen: .constant(false), book: Book(title: "", author: "", category: .currentlyReading, coverImageUrl: "https://books.google.com/books/content?id=54BEAAAACAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"))
        .modelContainer(container)
}
