//
//  TestScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 16/05/24.
//

import Foundation
import SplineRuntime
import SwiftUI

struct HomeScreen2: View {
    var body: some View {
        // fetching from cloud
        let url = URL(string: "https://build.spline.design/CnBGOQjeeH3RlgmJyC1Q/scene.splineswift")!

        try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
            .overlay(HomeView())
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen2()
            .environmentObject(TimerManager())
    }
}
