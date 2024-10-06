//
//  OpenableBookView.swift
//  BookNook
//
//  Created by Riley Jenum on 05/10/24.
//

import SwiftUI

struct OpenableBookView: View, Animatable {
    var bookOpenPercentage: CGFloat
    var width: CGFloat
    var height: CGFloat
    var shadowColor: Color
    var dividerBackground: Color
    @Binding var progress: Double
    
    var animatableData: CGFloat {
        get {
            return bookOpenPercentage
        }
        set {
            bookOpenPercentage = newValue
        }
    }

    var body: some View {
        let bookOpenProgress = max(min(bookOpenPercentage, 1), 0)
        let rotation = bookOpenProgress * -180

        ZStack {
            // Inside Right View
            VStack {
                Text("Progress")
                    .foregroundStyle(Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]))
                    .font(.system(size: 30, weight: .bold))
                CircularProgressView(progress: $progress)
                    .frame(width: width - 50)
            }
            .frame(width: width, height: height)
            .background(.background)
            .clipShape(.rect(
                topLeadingRadius: 3,
                bottomLeadingRadius: 3,
                bottomTrailingRadius: 15,
                topTrailingRadius: 15
            ))
            .shadow(color: shadowColor.opacity(0.1 * bookOpenProgress), radius: 5, x: 5, y: 0)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(dividerBackground.shadow(.inner(color: shadowColor.opacity(0.15), radius: 2)))
                    .frame(width: 6)
                    .offset(x: -3)
                    .clipped()
            }

            // Front View
            Image("BookCoverSample")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: 10)
                .frame(width: width, height: height)
                .overlay {
                    if -rotation > 90 {
                        // Inside Left View
                        VStack(spacing: 5) {

                        }
                        .frame(width: width, height: height)
                        .background(.background)
                        .scaleEffect(x: -1)
                        .transition(.identity)
                    }
                }
                .clipShape(.rect(
                    topLeadingRadius: 3,
                    bottomLeadingRadius: 3,
                    bottomTrailingRadius: 15,
                    topTrailingRadius: 15
                ))
                .shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 0)
                .rotation3DEffect(
                    .init(degrees: rotation),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    perspective: 0.3
                )
        }
        .offset(x: (width / 2) * bookOpenProgress)
        .frame(width: width, height: height)
    }
}

#Preview {
    VStack {
        OpenableBookView(bookOpenPercentage: 1.0, width: 200, height: 300, shadowColor: .black, dividerBackground: .white, progress: .constant(0.6))
    }
    .frame(width: 500, height: 800, alignment: .center)
    .background(.red)
}
