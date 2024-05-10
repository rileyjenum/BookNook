//
//  TopTitleView.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import Foundation
import SwiftUI

struct TopTitleView: View {
    var body: some View {
        VStack(alignment: .center, spacing:0) {
            Text("Reading Nook")
                .textStyle(title())
            Text("Bedroom")
                .foregroundColor(Color(hex: 0xffffff, alpha: 0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .preferredColorScheme(.dark)

    }
    
    // MARK: additional structs
    struct title: ViewModifier {
        func body(content: Self.Content) -> some View {
            content
                .font(.title)
                .lineSpacing(0.82)
                .tracking(0.36)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TopTitleView()
}
