//
//  UpdateReadingSessionView.swift
//  BookNook
//
//  Created by Riley Jenum on 12/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct UpdateReadingSessionView: View {

    @Bindable var session: ReadingSession
    @Environment(\.dismiss) var dismiss

    var isFormIncomplete: Bool {
        session.book.title.isEmpty || session.book.author.isEmpty || session.duration <= 0
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    DatePicker("Start Time", selection: $session.startTime, displayedComponents: [.date, .hourAndMinute])
                    TextField("Duration (in minutes)", value: $session.duration, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Book Title", text: $session.book.title)
                    TextField("Author", text: $session.book.author)
                    TextEditor(text: $session.notes)
                        .frame(height: 100)  // Set a reasonable height for text editing
                    Section(footer:
                                HStack {
                        Spacer()
                        Button("Update") {
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
            .navigationTitle("Update Session")
        }
    }
}
