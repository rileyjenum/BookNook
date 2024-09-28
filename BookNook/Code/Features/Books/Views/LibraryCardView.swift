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
    
    let geometry: GeometryProxy
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Library Card")
                    .font(.system(size: 30, weight: .semibold))
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()
                    .frame(height: 2)
                    .overlay(Color.black.opacity(0.5))

                Text("Title")
                    .font(.system(size: 20, weight: .medium))
                    .padding()
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black.opacity(0.4))
                
                Text("Author")
                    .font(.system(size: 20, weight: .medium))
                    .padding()
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black.opacity(0.7))
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black.opacity(0.7))
                
                HStack {
                    Text("Title")
                        .font(.system(size: 20, weight: .medium))
                        .padding()
                    Divider()
                        .frame(width: 1, height: 40)
                        .overlay(Color.black.opacity(0.7))

                    Text("A visual element that can be used to separate other content.")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors:  colors), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(3)
        .shadow(color: Color.black.opacity(0.25), radius: 10)
        .padding(.horizontal)


    }
}

#Preview {
    GeometryReader { geo in
        ZStack(alignment: .center) {
            Color.white.ignoresSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height: 160)
                    LibraryCardView(geometry: geo)
                }
            }
        }
    }
}
