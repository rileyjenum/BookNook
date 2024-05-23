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
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timerManager: TimerManager
    
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var allSessions: [ReadingSession]


    @State private var selectedBookIndex: Int = 0
    @State private var newBookTitle: String = ""
    @State private var newAuthor: String = ""
    @State private var notes: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

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
//        .preferredColorScheme(.dark)
        .padding()
        .mask(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: show)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                  message: Text(errorMessage),
                  dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $timerManager.showStopAlert) {
            Alert(title: Text("Stop Session"),
                  message: Text("Are you sure you want to stop the session?"),
                  primaryButton: .destructive(Text("Stop")) {
                    timerManager.stopTimer()
                  },
                  secondaryButton: .cancel())
        }
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
                Text("Add New Book").tag(0)
                ForEach(books.indices, id: \.self) { index in
                    Text(books[index].title).tag(index + 1)
                }
            }
            .onChange(of: selectedBookIndex) { newValue in
                if newValue > 0 {
                    newBookTitle = books[newValue - 1].title
                    newAuthor = books[newValue - 1].author
                } else {
                    newBookTitle = ""
                    newAuthor = ""
                }
            }
            .pickerStyle(MenuPickerStyle())

            if selectedBookIndex == 0 {
                TextField("Book Title", text: $newBookTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Author", text: $newAuthor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            TextField("Notes", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Start Session") {
                if canStartSession() {
                    if selectedBookIndex == 0 && isDuplicateTitle() {
                        showError = true
                        errorMessage = "A book with this title already exists. Please use a different title."
                    } else {
                        saveSession()
                    }
                } else {
                    showError = true
                    errorMessage = "Please fill in all fields."
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
        !(newBookTitle.isEmpty || newAuthor.isEmpty)
    }

    private func isDuplicateTitle() -> Bool {
        books.contains { $0.title.lowercased() == newBookTitle.lowercased() }
    }

    private func saveSession() {
        do {
            let book: Book
            if selectedBookIndex > 0 {
                book = books[selectedBookIndex - 1]
            } else {
                book = Book(title: newBookTitle, author: newAuthor)
                context.insert(book)
            }

            let newSession = ReadingSession(startTime: Date(), duration: 0, book: book, notes: notes)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TimerManager())
    }
}

