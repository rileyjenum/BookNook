//
//  MainTabbedScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import SwiftData

struct MainTabbedView: View {
    
    @State var selectedTab = 2
    @State private var pendingTab: Int?
    @State private var showPageEntry = false
    @State private var currentPage = 0
    @State private var selectedPage = 0
    @State private var selectedBookIndex: Int = 0
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    
    @EnvironmentObject var timerManager: TimerManager
    
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    @Environment(\.modelContext) var context

    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverScreen()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(0)
            BookViewTest()
                .tabItem {
                    Label("Books", systemImage: "book.closed")
                }
                .tag(1)
            HomeScreen2(selectedTab: $selectedTab, pendingTab: $pendingTab, showPageEntry: $showPageEntry, selectedBookIndex: $selectedBookIndex, currentPage: $currentPage, selectedPage: $selectedPage, showError: $showError, errorMessage: $errorMessage)
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
        .overlay(
            ZStack {
                if showPageEntry {
                    // Background overlay to capture all interactions
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                    
                    PageEntryModalView(
                        book: books[selectedBookIndex],
                        saveSession: saveSession,
                        cancelSession:  cancelSession,
                        showPageEntry: $showPageEntry,
                        currentPage: $currentPage,
                        selectedPage: $selectedPage,
                        selectedTab: $selectedTab,
                        pendingTab: $pendingTab
                    )
                    .frame(maxWidth: 300)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 20)
                    .padding()
                }
            }
        )
        .onChange(of: timerManager.isActive) {
            if !timerManager.isActive {
                showPageEntry = true
            }
        }
    }
    
    func attemptChangeTab(to index: Int) {
        if timerManager.isActive && index != 2 {
            pendingTab = index
            timerManager.requestStopTimer()
            selectedTab = 2
        } else {
            selectedTab = index
        }
    }
    
    private func saveSession() {
        do {
            let book = books[selectedBookIndex]
            let pagesRead = selectedPage - currentPage
            book.pagesRead! += pagesRead
            if let currentSession = timerManager.currentSession {
                currentSession.pagesRead = pagesRead
                try context.save()
                timerManager.completeSession() // Move completion after saving
            }
        } catch {
            showError = true
            errorMessage = "Failed to save session: \(error.localizedDescription)"
        }
    }

    private func cancelSession() {
        if let currentSession = timerManager.currentSession {
            context.delete(currentSession)
            timerManager.completeSession()
        }
        do {
            try context.save()
        } catch {
            showError = true
            errorMessage = "Failed to delete session: \(error.localizedDescription)"
        }
    }
}
