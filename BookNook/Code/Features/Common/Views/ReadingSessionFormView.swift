//
//  ReadingSessionFormView.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ReadingSessionFormView: View {
    @State private var startTime = Date()
    @State private var durationMinutes: Int = 0
    @State private var bookTitle: String = ""
    @State private var author: String = ""
    @State private var notes: String = ""
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?

    var isFormIncomplete: Bool {
        bookTitle.isEmpty || author.isEmpty || durationMinutes <= 0
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    TextField("Duration (in minutes)", value: $durationMinutes, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focus, equals: true)
                    TextField("Book Title", text: $bookTitle)
                    TextField("Author", text: $author)
                    TextEditor(text: $notes)
                        .frame(height: 100)  // Set a reasonable height for text editing
                    Section(footer:
                                HStack {
                        Spacer()
                        Button("Add Session") {
                            createSession()
                            dismiss()
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
        let newSession = ReadingSession(
            id: UUID().uuidString,
            startTime: startTime,
            duration: TimeInterval(durationMinutes * 60),  // Convert minutes to seconds
            bookTitle: bookTitle,
            author: author,
            notes: notes
        )
        // Save new session logic, depending on your data management
    }
}

struct ReadingSessionFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingSessionFormView()
    }
}

