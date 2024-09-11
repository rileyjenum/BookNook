//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct Playground: View {
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(0..<10) { index in
                    Text("Item \(index)")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .frame(width: 200, height: 200)
                        .background(.red)
                        .offset(y: selectedIndex == index ? -300 : 0) // Adjust the offset value as needed
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = (selectedIndex == index) ? nil : index
                            }
                        }
                }
            }
            .frame(width: .infinity, height: 800)
            .ignoresSafeArea(.all)
            .background(.blue)
        }
    }
}

struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
