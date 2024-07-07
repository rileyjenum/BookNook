//
//  MainTabbedScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI

struct MainTabbedView: View {
    
    @State var selectedTab = 2
    @State private var pendingTab: Int?
    
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverScreen()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(0)
            BookListScreen2()
                .tabItem {
                    Label("Books", systemImage: "book.closed")
                }
                .tag(1)
            HomeScreen2(selectedTab: $selectedTab, pendingTab: $pendingTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(2)
                .environmentObject(timerManager)
            CalendarScreen()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
                .tag(3)
            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .onChange(of: selectedTab) {
            attemptChangeTab(to: selectedTab)
        }
        .alert(isPresented: $timerManager.showStopAlert) {
            Alert(
                title: Text("Stop Reading Session?"),
                message: Text("Do you really want to stop your current session?"),
                primaryButton: .destructive(Text("Stop")) {
                    timerManager.stopTimer()
                },
                secondaryButton: .cancel {
                    pendingTab = nil
                }
            )
        }
    }
    
    func attemptChangeTab(to index: Int) {
        if timerManager.isActive && index != 2 { // Only trigger the alert if trying to leave the Home tab while a session is active
            pendingTab = index
            timerManager.requestStopTimer()
            // Revert the selected tab to the current one, as the change is pending confirmation
            selectedTab = 2
        } else {
            selectedTab = index
        }
    }
}

struct MyView: View {
    var body: some View {
        MainTabbedView()
            .environmentObject(TimerManager())
    }
}

#Preview {
    MyView()
}
