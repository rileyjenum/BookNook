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
    @Binding var showPageEntry: Bool
    @Binding var selectedBookIndex: Int
    @Binding var currentPage: Int
    @Binding var selectedPage: Int
    @Binding var showError: Bool
    @Binding var errorMessage: String
    
    var body: some View {
        let url = URL(string: "https://build.spline.design/CnBGOQjeeH3RlgmJyC1Q/scene.splineswift")!

        try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
            .overlay(HomeView(selectedTab: $selectedTab, pendingTab: $pendingTab, showPageEntry: $showPageEntry, selectedBookIndex: $selectedBookIndex, currentPage: $currentPage, selectedPage: $selectedPage, showError: $showError, errorMessage: $errorMessage))
    }
}
