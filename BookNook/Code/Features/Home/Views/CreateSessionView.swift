import SwiftUI
import SwiftData

struct CreateSessionView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timerManager: TimerManager

    @State private var selectedBookIndex: Int = 0
    @State private var newBookTitle: String = ""
    @State private var newAuthor: String = ""
    @State private var notes: String = ""
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
                .onChange(of: selectedBookIndex) {
                    if selectedBookIndex > 0 {
                        newBookTitle = books[selectedBookIndex - 1].title
                        newAuthor = books[selectedBookIndex - 1].author
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

                Button("Start Session") {
                    if canStartSession() {
                        // Only check for duplicates if a new book is being added
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
            }
            .navigationBarTitle("New Reading Session", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
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
//TODO: fix pagesRead issue
            let newSession = ReadingSession(startTime: Date(), duration: 0, book: book, notes: notes, pagesRead: 0)
            context.insert(newSession)
            try context.save()

            timerManager.startTimer(session: newSession)
            dismiss()
        } catch {
            showError = true
            errorMessage = "Failed to save session: \(error.localizedDescription)"
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSessionView()
            .environmentObject(TimerManager())
    }
}

