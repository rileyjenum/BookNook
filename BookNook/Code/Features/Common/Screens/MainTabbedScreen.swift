//
//  MainTabbedScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import Foundation

import SwiftUI

struct MainTabbedView: View {
    @State var selectedTab = 0
    @State private var pendingTab: Int?
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeScreen2()
                    .tag(0)
                    .environmentObject(timerManager)
                BooksListScreen()
                    .tag(1)
                CalendarScreen()
                    .tag(2)
                SettingsScreen()
                    .tag(3)
            }
            
            tabBar
            
        }
        .alert(isPresented: $timerManager.showStopAlert) {
            Alert(
                title: Text("Stop Reading Session?"),
                message: Text("Do you really want to stop your current session?"),
                primaryButton: .destructive(Text("Stop")) {
                    timerManager.stopTimer()
                    if let tab = pendingTab {
                        selectedTab = tab
                        pendingTab = nil
                    }
                },
                secondaryButton: .cancel {
                    pendingTab = nil
                }
            )
        }
    }
    
    var tabBar: some View {
        HStack(alignment: .top, spacing: 0) {
            tabButton(icon: "house", title: "Home", index: 0)
            tabButton(icon: "book.closed", title: "Books", index: 1)
            tabButton(icon: "calendar", title: "History", index: 2)
            tabButton(icon: "gear", title: "Settings", index: 3)
        }
        .padding([.horizontal, .bottom], 10)
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.black.opacity(0.7)) // Adjusted for better visibility
        .cornerRadius(20)
    }
    
    func tabButton(icon: String, title: String, index: Int) -> some View {
        Button {
            attemptChangeTab(to: index)
        } label: {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .frame(width: 44, height: 44)
                Text(title)
                    .font(.caption)
                    .lineSpacing(0.75)
            }
            .foregroundColor(selectedTab == index ? .yellow : .white)
            .frame(maxWidth: .infinity)
        }
    }
    
    func attemptChangeTab(to index: Int) {
        if timerManager.isActive && index != 0 { // Only trigger the alert if trying to leave the Home tab while a session is active
            pendingTab = index
            timerManager.requestStopTimer()
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
