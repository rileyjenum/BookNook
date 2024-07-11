//
//  HomeView.swift
//  BookNook
//
//  Created by Riley Jenum on 16/05/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Namespace private var namespace
    
    @State private var show = false
    
    @Binding var selectedTab: Int
    @Binding var pendingTab: Int?
    @Binding var showPageEntry: Bool
    @Binding var selectedBookIndex: Int
    @Binding var currentPage: Int
    @Binding var selectedPage: Int
    @Binding var showError: Bool
    @Binding var errorMessage: String
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timerManager: TimerManager
    
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var allSessions: [ReadingSession]
    
    // Query existing books
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    
    var body: some View {
        VStack {
            headerView()
            
            if show {
                expandedView()
                    .transition(.opacity)
            }
            Spacer()
            AudioPlayerView()
        }
        .padding()
        .mask(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: show)
    }
    
    private func stopSession() {
        timerManager.stopTimer()
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            if timerManager.isActive {
                Text(formattedTime(timerManager.elapsedTime))
                    .padding()
            } else {
                Text("Ready to read?")
                    .font(.custom(
                        "AmericanTypewriter",
                        fixedSize: 19))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                Text("Today's Reading Time: \(formattedTime(totalReadingTimeToday()))")
            }
            Spacer()
            Button(action: {
                if timerManager.isActive {
                    timerManager.requestStopTimer()
                } else {
                    withAnimation {
                        show.toggle()
                    }
                }
            }) {
                Image(systemName: timerManager.isActive ? "stop.fill" : "play.fill")
                    .padding()
            }
        }
        .frame(width: 300, height: 100, alignment: .center)
        .background(
            Color.white.opacity(0.7)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
        )
        .padding()
    }
    
    @ViewBuilder
    private func expandedView() -> some View {
        VStack(spacing: 16) {
            Picker("Select Book", selection: $selectedBookIndex) {
                ForEach(books.indices, id: \.self) { index in
                    Text(books[index].title).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Start Session") {
                if canStartSession() {
                    startNewSession()
                } else {
                    showError = true
                    errorMessage = "Please select a book."
                }
            }
            .buttonStyle(DefaultButtonStyle())
        }
        .padding()
        .background(
            Color.gray.opacity(1)
                .matchedGeometryEffect(id: "backgroundExpanded", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .matchedGeometryEffect(id: "maskExpanded", in: namespace)
        )
    }
    
    private func canStartSession() -> Bool {
        selectedBookIndex < books.count
    }
    
    private func startNewSession() {
        do {
            let book = books[selectedBookIndex]
            let newSession = ReadingSession(startTime: Date(), duration: 0, book: book, notes: "", pagesRead: 0)
            context.insert(newSession)
            try context.save()
            
            timerManager.startTimer(session: newSession)
            withAnimation {
                show.toggle()
            }
        } catch {
            showError = true
            errorMessage = "Failed to save session: \(error.localizedDescription)"
        }
    }
    
    private func totalReadingTimeToday() -> TimeInterval {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        let todaySessions = allSessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: startOfDay)
        }
        
        return todaySessions.reduce(0) { $0 + $1.duration }
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
