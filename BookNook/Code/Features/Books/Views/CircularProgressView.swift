//
//  CircularProgressView.swift
//  BookNook
//
//  Created by Riley Jenum on 05/10/24.
//

import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    lineWidth: 15
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            // Use AnimatingNumberView for the animated text
            AnimatingNumberView(value: progress * 100)
                .foregroundStyle(Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]))
                .font(.system(size: 40, weight: .bold))
        }
    }
}

struct AnimatingNumberView: Animatable, View {
    var value: Double

    // AnimatableData is the value that SwiftUI will animate.
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    var body: some View {
        Text("\(Int(value))%") // Display the animated value
    }
}




#Preview {
    CircularProgressView(progress:.constant(0.6))
        .frame(width: 200, height: 200)

}
