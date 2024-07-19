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
    @Binding var selectedBook: Book?
    @State private var bookHeight: CGFloat = CGFloat.random(in: 150...200)

    @Namespace private var cubeNS
    
    var degrees: Double {
        (isRotated ? 0.99999 : 0) * 90
    }
    
    var radians: Double {
        (isRotated ? 0.999999 : 0) * (Double.pi / 2)
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
                            .frame(width: bookHeight, height: 40)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.5)
                            .allowsTightening(true)
                        Spacer()
                    }
                    .frame(width: 40, height: bookHeight)

                }
                .background(bookColor(book))
                .frame(width: 40, height: bookHeight)
                .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .trailing, isSource: true)
                .rotation3DEffect(
                    .degrees(-degrees),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    perspective: 1.0
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        if selectedBook == book {
                            isRotated = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isScaleEnabled = false
                                    selectedBook = nil
                                }
                            }
                        } else {
                            selectedBook = book
                            isScaleEnabled.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    isRotated.toggle()
                                }
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
                    perspective: 0.25
                )
                .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .leading, isSource: false)
                .scaleEffect(1 + sin(radians) * 0.32)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        if selectedBook == book {
                            isRotated.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isScaleEnabled.toggle()
                                    selectedBook = nil
                                }
                            }
                        } else {
                            isRotated.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isScaleEnabled.toggle()
                                    selectedBook = book

                                }
                            }
                        }
                    }
                }
            }
            .frame(width: 40)
            .scaleEffect(isScaleEnabled ? 1.3 : 1, anchor: .center)
            .offset(x: isRotated ? -80 : 0)
            .onChange(of: selectedBook) {
                if selectedBook != book {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isRotated = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isScaleEnabled = false
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 40, height: bookHeight)
    }
    
    private func bookColor(_ book: Book) -> Color {
        return Color(hue: Double(book.title.hashValue % 256) / 256.0, saturation: 0.7, brightness: 0.9)
    }
}
