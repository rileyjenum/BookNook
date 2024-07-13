//
//  TEST.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct TestView: View {
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
        VStack {
            Color.orange
                .frame(width: 200, height: 200)
                .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .leading, isSource: false)
                .rotation3DEffect(
                    .degrees(-degrees + 90),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    perspective: 0.25
                )
                .scaleEffect(1 + sin(radians) * 0.38) // <-- 🤔
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isRotated.toggle()
                    }
                }
            
            Color.red
                .frame(width: 200, height: 200)
                .matchedGeometryEffect(id: "cube", in: cubeNS, properties: .position, anchor: .trailing, isSource: true)
                .rotation3DEffect(
                    .degrees(-degrees),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    perspective: 0.25
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isRotated.toggle()
                    }
                }
            
        }
    }
}

#Preview {
    TestView()
}
