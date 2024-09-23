//
//  SplashScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 07/07/24.
//

import SwiftUI
import Dispatch


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
                    Image(systemName: "book.fill")
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
        let dispatchGroup = DispatchGroup()
        
//        for category in categories {
//            dispatchGroup.enter()
//            DiscoverScreenViewModel.shared.fetchBestsellers(for: category) {
//                dispatchGroup.leave()
//            }
//        }
        
        dispatchGroup.notify(queue: .main) {
            self.isActive = true
        }
    }}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
