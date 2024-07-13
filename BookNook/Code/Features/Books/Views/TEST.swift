//
//  TEST.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct TestView: View {
    
    @Binding var bookColor: Color
    var bookHeight: Double // Change this to a non-binding variable

    var calculatedPerspective: Double {
    return bookHeight / 200
    }
    
    @State private var isRotated = false
    @State private var isScaleEnabled = false
    
    @Namespace private var cubeNS
    
    var degrees: Double {
        (isRotated ? 0.99999 : 0) * 90
    }
    
    var radians: Double {
        (isRotated ? 0.999999 : 0) * (Double.pi / 2)
    }
    
    var body: some View {
        Group {
            ZStack {
                bookColor
                
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]), startPoint: .leading, endPoint: .trailing)
            }
            .frame(width: 40, height: bookHeight)
            .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .trailing, isSource: true)
            .rotation3DEffect(
                .degrees(-degrees),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                anchor: .leading,
                perspective: 1.0
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isScaleEnabled.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isRotated.toggle()
                    }
                }
            }
            
            
            ZStack {
                bookColor
                
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]), startPoint: .leading, endPoint: .trailing)
            }
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
                    isRotated.toggle()
                }
                // Delay the rotation toggle until the scale animation is finished
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isScaleEnabled.toggle()
                    }
                }
            }
        }
        .scaleEffect(isScaleEnabled ? 1.3 : 1, anchor: .center)
        .offset(x: isRotated ? -80 : 0)
    }
}

#Preview {
    TestView(bookColor: .constant(.brown), bookHeight: 200)
}
