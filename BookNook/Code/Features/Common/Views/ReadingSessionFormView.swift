//
//  ReadingSessionFormView.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//

import SwiftUI
import SwiftData

struct ReadingSessionFormView: View {
    @Environment(\.modelContext) var context
    @State private var startTime = Date()
    @State private var durationMinutes: Int = 0
    @State private var selectedBook: Book?
    @State private var isNewBook: Bool = false
    @State private var bookTitle: String = ""
    @State private var author: String = ""
    @State private var notes: String = ""
    @Query private var existingBooks: [Book] = []
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                TextField("Duration (in minutes)", value: $durationMinutes, format: .number)
                    .keyboardType(.numberPad)
                
                Toggle(isOn: $isNewBook) {
                    Text("Add New Book")
                }
                
                if !isNewBook {
                    Picker("Select a Book", selection: $selectedBook) {
                        ForEach(existingBooks, id: \.id) { book in
                            Text(book.title).tag(book as Book?)
                        }
                    }
                    .onChange(of: selectedBook) { newValue in
                        bookTitle = newValue?.title ?? ""
                        author = newValue?.author ?? ""
                    }
                } else {
                    TextField("Book Title", text: $bookTitle)
                    TextField("Author", text: $author)
                }
                
                TextEditor(text: $notes)
                    .frame(height: 100)
                
                Button("Add Session") {
                    createSession()
                }
                .buttonStyle(.borderedProminent)
                .disabled((isNewBook && (bookTitle.isEmpty || author.isEmpty)) || durationMinutes <= 0)
            }
            .navigationTitle("New Session")
        }
    }

    private func createSession() {
        let book: Book
        if !isNewBook, let selectedBook = selectedBook {
            book = selectedBook
        } else {
            let newBook = Book(title: bookTitle, author: author)
            context.insert(newBook)
            book = newBook
        }

        let newSession = ReadingSession(
            startTime: startTime,
            duration: TimeInterval(durationMinutes * 60),
            book: book,
            notes: notes
        )
        book.sessions.append(newSession)
        context.insert(newSession)
        try? context.save()
        dismiss()
    }
}

struct ReadingSessionFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingSessionFormView()
    }
}
