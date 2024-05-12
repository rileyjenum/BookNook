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
                } else {
                    Text("Author: \(newAuthor)")
                }

                TextField("Notes", text: $notes)
                Text("Start Time: \(startTime, formatter: Formatter.item)")
                Slider(value: $duration, in: 300...18000, step: 300) {
                    Text("Duration: \(durationString(duration))")
                }
                Button("Start Session") {
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
        let book: Book
        if selectedBookIndex > 0 {
            // Selecting an existing book
            book = books[selectedBookIndex - 1]
        } else {
            // Creating a new book
            book = Book(title: newBookTitle, author: newAuthor)
            context.insert(book)
        }

        // Create a new session linked to either the selected or new book
        let newSession = ReadingSession(startTime: startTime, duration: duration, book: book, notes: notes)
        
        // It's critical here to ensure the new session is added to the book's session collection if your model supports relationships
        book.sessions.append(newSession)

        // Insert the new session into the context
        context.insert(newSession)


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
