import SwiftUI
import SwiftData

struct BottomSheetView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timerManager: TimerManager

    @State private var selectedBookIndex: Int = 0
    @State private var newBookTitle: String = ""
    @State private var newAuthor: String = ""
    @State private var notes: String = ""
    @State private var duration: TimeInterval = 300 // Default to 5 minutes
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    // Query existing books
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]

    var body: some View {
        NavigationView {
            Form {
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

                if selectedBookIndex == 0 {
                    TextField("Book Title", text: $newBookTitle)
                    TextField("Author", text: $newAuthor)
                }

                TextField("Notes", text: $notes)

                Text("Duration: \(durationString(duration))").padding()
                Slider(value: $duration, in: 300...18000, step: 300) {
                    Text("Adjust Duration")
                }

                Button("Start Session") {
                    if canStartSession() {
                        // Only check for duplicates if a new book is being added
                        if selectedBookIndex == 0 && isDuplicateTitle() {
                            showError = true
                            errorMessage = "A book with this title already exists. Please use a different title."
                        } else {
                            saveSession()
                        }
                    }
                }

            }
            .navigationBarTitle("New Reading Session", displayMode: .inline)
            .toolbar {
                Button("Dismiss") {
                    dismiss()
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    private func durationString(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return "\(hours) hr \(minutes) min"
    }

    private func canStartSession() -> Bool {
        !(newBookTitle.isEmpty || newAuthor.isEmpty)
    }

    private func isDuplicateTitle() -> Bool {
        books.contains { $0.title.lowercased() == newBookTitle.lowercased() }
    }

    private func saveSession() {
        let book: Book
        if selectedBookIndex > 0 {
            book = books[selectedBookIndex - 1]
        } else {
            book = Book(title: newBookTitle, author: newAuthor)
            context.insert(book)
        }

        let newSession = ReadingSession(startTime: Date(), duration: duration, book: book, notes: notes)
        book.sessions.append(newSession)
        context.insert(newSession)

        timerManager.startTimer(session: newSession)
        
        dismiss()
    }
}
