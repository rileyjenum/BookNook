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
    @FocusState private var focus: Bool?

    var isFormIncomplete: Bool {
        (isNewBook && (bookTitle.isEmpty || author.isEmpty)) || durationMinutes <= 0
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    TextField("Duration (in minutes)", value: $durationMinutes, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focus, equals: true)
                    Picker("Select a Book", selection: $selectedBook) {
                        Text("Add New Book").tag(nil as Book?)
                        ForEach(existingBooks, id: \.id) { book in
                            Text(book.title).tag(book as Book?)
                        }
                    }
                    .onChange(of: selectedBook) { _ in
                        isNewBook = selectedBook == nil
                        bookTitle = selectedBook?.title ?? ""
                        author = selectedBook?.author ?? ""
                    }
                    if isNewBook {
                        TextField("Book Title", text: $bookTitle)
                        TextField("Author", text: $author)
                    }
                    TextEditor(text: $notes)
                        .frame(height: 100)
                    Section(footer:
                                HStack {
                                    Spacer()
                                    Button("Add Session") {
                                        createSession()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(isFormIncomplete)
                                    Spacer()
                                }) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("New Session")
            .onAppear {
                focus = true
            }
        }
    }


    private func createSession() {
        let book: Book
        if let selectedBook = selectedBook {
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
        context.insert(newSession)
        dismiss()
    }
}

struct ReadingSessionFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingSessionFormView()
    }
}
