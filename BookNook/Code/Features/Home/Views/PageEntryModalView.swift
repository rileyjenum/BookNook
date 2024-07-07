//
//  PageEntryModalView.swift
//  BookNook
//
//  Created by Riley Jenum on 25/06/24.
//

import SwiftUI

struct PageEntryModalView: View {
    var book: Book
    @Binding var showPageEntry: Bool
    @Binding var currentPage: Int
    @Binding var selectedPage: Int
    var saveSession: () -> Void
    var cancelSession: () -> Void
    @Binding var selectedTab: Int
    @Binding var pendingTab: Int?

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter pages read")
                .font(.headline)

            Text("Current Page: \(currentPage)")
                .padding()

            Picker("Select Page", selection: $selectedPage) {
                ForEach(0..<(book.pageCount ?? 0), id: \.self) { page in
                    Text("\(page)").tag(page)
                }
            }
            .pickerStyle(MenuPickerStyle())

            HStack {
                Button("Save") {
                    saveSession()
                    showPageEntry = false
                    if let tab = pendingTab {
                        selectedTab = tab
                        pendingTab = nil
                    }
                }
                .buttonStyle(DefaultButtonStyle())

                Button("Cancel") {
                    cancelSession()
                    showPageEntry = false
                    if let tab = pendingTab {
                        selectedTab = tab
                        pendingTab = nil
                    }
                }
                .buttonStyle(DefaultButtonStyle())
            }
        }
        .padding()
        .cornerRadius(12)
        .shadow(radius: 20)
        .onAppear {
            currentPage = book.pagesRead ?? 0
            selectedPage = book.pagesRead ?? 0
            print("Page count: \(book.pageCount ?? 0)")  // Debug print statement
            print("Current Page: \(currentPage)")  // Debug print statement
        }
    }
}
