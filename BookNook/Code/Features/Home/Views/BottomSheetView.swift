import SwiftUI
import SwiftData

struct BottomSheetView: View {
    @Environment(\.modelContext) var context

    @Environment(\.dismiss) var dismiss
    @State private var selectedBookIndex: Int = 0
    @State private var newBookTitle: String = ""
    @State private var newAuthor: String = ""
    @State private var notes: String = ""
    @State private var duration: TimeInterval = 300 // Default to 5 minutes
    @State private var startTime: Date = Date() // Automatically set to current time
    
    // Query existing books and authors
    @Query(sort: [SortDescriptor(\ReadingSession.bookTitle)]) var sessions: [ReadingSession]

    var books: [String] {
        let uniqueBooks = Set(sessions.map { $0.bookTitle })
        return ["Add New Book"] + Array(uniqueBooks)
    }
    var authors: [String] {
        let uniqueAuthors = Set(sessions.map { $0.author })
        return [""] + Array(uniqueAuthors)
    }

    var body: some View {
        NavigationView {
            Form {
                Picker("Select Book", selection: $selectedBookIndex) {
                    ForEach(0..<books.count, id: \.self) { index in
                        Text(books[index]).tag(index)
                    }
                }
                .onChange(of: selectedBookIndex) { index in
                    if index > 0 {
                        newBookTitle = books[index]
                        newAuthor = authors[index]
                    } else {
                        newBookTitle = ""
                        newAuthor = ""
                    }
                }

                if selectedBookIndex == 0 {
                    TextField("Book Title", text: $newBookTitle)
                    TextField("Author", text: $newAuthor)
                } else {
                    Text("Author: \(newAuthor)")
                }

                TextField("Notes", text: $notes)
                Text("Start Time: \(startTime, formatter: Formatter.item)")
                Slider(value: $duration, in: 300...18000, step: 300) {
                    Text("Duration: \(durationString(duration))")
                }
                Button("Save Session") {
                    saveSession()
                }
            }
            .navigationBarTitle("New Reading Session", displayMode: .inline)
            .toolbar {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
    }

    private func durationString(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return "\(hours) hr \(minutes) min"
    }

    private func saveSession() {
        let newSession = ReadingSession(id: UUID().uuidString,startTime: startTime, duration: duration, bookTitle: newBookTitle, author: newAuthor, notes: notes)
        context.insert(newSession)
        try? context.save()
        dismiss()
    }
}

struct Formatter {
    static let item: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
