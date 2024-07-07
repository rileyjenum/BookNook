//
//  SplashScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 07/07/24.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var isActive = false
    @State private var loadingText = "Loading..."
    
    private let categories = ["young-adult-hardcover", "hardcover-fiction", "hardcover-nonfiction"]

    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                VStack {
                    Image(systemName: "book.fill") // Replace with your app logo
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()

                    Text("BookNook")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(loadingText)
                        .padding(.top, 20)
                        .onAppear {
                            performLoading()
                        }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: isActive)
            }
        }
    }

    private func performLoading() {
        
        self.isActive = true

    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
