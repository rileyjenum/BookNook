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
    @Binding var selectedTab: Int
    @Binding var pendingTab: Int?
    var body: some View {
        let url = URL(string: "https://build.spline.design/CnBGOQjeeH3RlgmJyC1Q/scene.splineswift")!

        try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
            .overlay(HomeView(selectedTab: $selectedTab, pendingTab: $pendingTab))
    }
}

