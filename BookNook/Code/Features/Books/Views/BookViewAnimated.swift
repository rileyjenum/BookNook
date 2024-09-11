//
//  BookViewAnimated.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI


struct BookViewAnimated: View {
    
    var book: Book
    
    @State private var isRotated = false
    @State private var isScaleEnabled = false
    
    @Binding var isAnimating: Bool
    @Binding var selectedBook: Book?
    @Binding var bookHeight: CGFloat
    @Binding var bookWidth: CGFloat

    @Namespace private var cubeNS
    
    var degrees: Double {
        (isRotated ? 0.99999 : 0.00001) * 90
    }
    
    var radians: Double {
        (isRotated ? 0.999999 : 0.00001) * (Double.pi / 2)
    }
    var perspective: Double {
        // Polynomial coefficients from the Python fit
        let a: Double = 0.00207143
        let b: Double = -0.18728571
        let c: Double = 4.09

        // Polynomial effect for the given width
        let polynomialEffect = a * pow(Double(bookWidth), 2) + b * bookWidth + c

        let perspective = (bookHeight / 200) + polynomialEffect
        return perspective
    }
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]), startPoint: .leading, endPoint: .trailing)
                    VStack {
                        Spacer()
                        Text(book.title)
                            .rotationEffect(.degrees(90))
                            .frame(width: bookHeight, height: bookWidth)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.5)
                            .allowsTightening(true)
                        Spacer()
                    }
                    .frame(width: bookWidth, height: bookHeight)

                }
                .background(bookColor(book))
                .frame(width: bookWidth, height: bookHeight)
                .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .trailing, isSource: true)
                .rotation3DEffect(
                    .degrees(-degrees),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    perspective: perspective
                )
                .onTapGesture {
                    isAnimating = true
                    withAnimation(.easeInOut(duration: 0.5)) {
                        selectedBook = book
                        isScaleEnabled = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isRotated = true
                                isAnimating = false

                            }
                        }
                    }
                }
                
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]), startPoint: .leading, endPoint: .trailing)
                    
                    Text(book.title)
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.top, 10)
                }
                .background(bookColor(book))
                .frame(width: 130, height: bookHeight)
                .rotation3DEffect(
                    .degrees(-degrees + 90),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    perspective: 0.5
                )
                .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .leading, isSource: false)
                .scaleEffect(1 + sin(radians) * 0.32)
                .onTapGesture {
                    isAnimating = true
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isRotated = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isScaleEnabled.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut) {
                                        isAnimating = false
                                        selectedBook = nil
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: bookWidth)
            .scaleEffect(isScaleEnabled ? 1.3 : 1.0, anchor: .center)
            .offset(x: isRotated ? -80 : 0, y: isRotated ? -80 : 0)
        }
        .frame(width: bookWidth, height: bookHeight)
    }
    
    private func bookColor(_ book: Book) -> Color {
        return Color(hue: Double(book.title.hashValue % 256) / 256.0, saturation: 0.7, brightness: 0.9)
    }
}


import SwiftData

struct BookViewAnimatedPreview: View {
    @State var selectedBook: Book? = Book(title: "", author: "", category: .haveRead)
    @State private var isAnimating = false


    var book: Book = Book(title: "", author: "", category: .haveRead)
    var body: some View {
        BookViewAnimated(book: book, isAnimating: $isAnimating, selectedBook: $selectedBook, bookHeight: .constant(220), bookWidth: .constant(30))
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
    
    return BookViewAnimatedPreview()
        .modelContainer(container)
}
