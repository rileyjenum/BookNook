//
//  BookDashboard.swift
//  BookNook
//
//  Created by Riley Jenum on 04/10/24.
//

import SwiftUI

struct BookDashboard: View {
    
    @State private var bookOpenPercentage: CGFloat = 0
    @State private var progress: Double = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let width = geo.size.width / 2 - 20
                let height = width * 1.5
                
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .center) {
                            OpenableBookView(
                                bookOpenPercentage: bookOpenPercentage,
                                width: width,
                                height: height,
                                shadowColor: .black,
                                dividerBackground: .white,
                                progress: $progress
                            )
                            .frame(width: width, height: height)
                            
                            
                            Button("Open") {
                                withAnimation(.snappy(duration: 1)) {
                                    bookOpenPercentage = (bookOpenPercentage == 1 ? 0 : 1.0)
                                    progress = 0.62
                                }
                            }
                            .foregroundStyle(Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]))
                            .padding(.top)
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.init(hex: "FAF9F6"))
                                    .frame(width: geo.size.width)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
                                VStack {
                                    Text("Dashboard")
                                        .font(.system(size: 35, weight: .bold))
                                        .padding()
                                    Spacer()
                                }
                            }
                            .padding(.top)
                            .frame(height: 6800)

                        }
                        .frame(maxWidth: .infinity)
                        .padding(15)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .navigationTitle("Book View")
            .toolbarBackground(Color.init(hex: "FAF9F6"), for: .navigationBar)
        }
    }
}

#Preview {
    BookDashboard()
}
