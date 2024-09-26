//
//  LibraryCardView.swift
//  BookNook
//
//  Created by Riley Jenum on 26/09/24.
//

import SwiftUI

struct LibraryCardView: View {
    
    let colors = [
        Color(red: 0.75, green: 0.72, blue: 0.65),
        Color(red: 0.95, green: 0.92, blue: 0.85)
    ]
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("daklj")
            }
        }
        .frame(width: 400, height: 1000)
        .background(LinearGradient(gradient: Gradient(colors:  colors), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(3)

    }
}

#Preview {
    LibraryCardView()
}
