//
//  BookSpineView.swift
//  BookNook
//
//  Created by Riley Jenum on 06/07/24.
//

//import Foundation
//import SwiftUI
//
//struct BookSpineView: View {
//    
//    let spineColor: Color
//    let textColor: Color
//    let isSelected: Bool
//    let opacity: Double
//    let title: String
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 5)
//                .fill(spineColor)
//                .frame(width: 40, height: 180)
//                .zIndex(isSelected ? 1 : 0)
//                .animation(.easeInOut(duration: 0.5), value: isSelected)
//            
//            Text(title)
//                .font(.caption)
//                .foregroundColor(textColor)
//                .frame(width: 180, height: 40)
//                .rotationEffect(.degrees(90))
//                .multilineTextAlignment(.center)
//                .scaleEffect(isSelected ? 1 : 1)
//                .zIndex(isSelected ? 1 : 0)
//                .animation(.easeInOut(duration: 0.5), value: isSelected)
//                .lineLimit(nil)
//                .allowsTightening(true)
//        }
//    }
//}
//
