//
//  ReadingSessionFormView.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//

import SwiftUI
import SwiftData

struct NewReadingSessionView: View {
    @Environment(\.modelContext) var context
    @State private var startTime = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
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
                
                // Duration Pickers for hours and minutes
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hr")
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 80)

                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min")
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 80)
                
                
                    Picker("Select a Book", selection: $selectedBook) {
                        ForEach(existingBooks, id: \.self) { book in
                            Text(book.title).tag(book as Book?)
                        }
                    }
                    .onChange(of: selectedBook) {
                        bookTitle = selectedBook?.title ?? ""
                        author = selectedBook?.author ?? ""
                    }

                
                TextEditor(text: $notes)
                    .frame(height: 100)
                
                Button("Add Session") {
                    createSession()
                }
                .buttonStyle(.borderedProminent)
                .disabled((hours == 0 && minutes == 0) || existingBooks.isEmpty)
            }
            .navigationTitle("New Session")
            .onAppear {
                if selectedBook == nil, !existingBooks.isEmpty {
                    selectedBook = existingBooks.first
                    bookTitle = existingBooks.first?.title ?? ""
                    author = existingBooks.first?.author ?? ""
                }
            }
        }
    }

    private func createSession() {
        let book: Book
        if let selectedBook = selectedBook {
            book = selectedBook
        } else {
            book = Book(title: "", author: "")
        }
        //TODO: fix pagesRead issue

        let durationInSeconds = TimeInterval(hours * 3600 + minutes * 60)
        let newSession = ReadingSession(
            startTime: startTime,
            duration: durationInSeconds,
            book: book,
            notes: notes, 
            pagesRead: 0
        )
        context.insert(newSession)
        try? context.save()
        dismiss()
    }
}

struct ReadingSessionFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewReadingSessionView()
    }
}
