//
//  MainTabbedScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import SwiftData

struct MainTabbedView: View {
    
    @State var selectedTab = 1
    @State var currentlyReadingCachedBooks: [Book] = []
    @State var haveReadCachedBooks: [Book] = []
    @State var willReadCachedBooks: [Book] = []

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverScreen(currentlyReadingCachedBooks: $currentlyReadingCachedBooks, haveReadCachedBooks: $haveReadCachedBooks, willReadCachedBooks: $willReadCachedBooks)
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(0)
            BookListScreen(currentlyReadingCachedBooks: $currentlyReadingCachedBooks, haveReadCachedBooks: $haveReadCachedBooks, willReadCachedBooks: $willReadCachedBooks)
                .tabItem {
                    Label("Books", systemImage: "book.closed")
                }
                .tag(1)
            CalendarScreen()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
                .tag(2)
        }
    }
}
