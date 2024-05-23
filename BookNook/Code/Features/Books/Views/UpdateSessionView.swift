//
//  UpdateSessionView.swift
//  BookNook
//
//  Created by Riley Jenum on 23/05/24.
//

import SwiftUI

struct UpdateSessionView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Bindable var session: ReadingSession

    var isFormIncomplete: Bool {
        session.book.title.isEmpty || session.book.author.isEmpty || session.notes.isEmpty || session.duration <= 0 /*|| session.startTime == nil*/
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    DatePicker("Start Time", selection: $session.startTime, displayedComponents: [.date, .hourAndMinute])
                    
                    TextField("Duration (in seconds)", value: $session.duration, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    TextField("Notes", text: $session.notes)
                    
                    Section(footer:
                        HStack {
                            Spacer()
                            Button("Update") {
                                dismiss()
                                try? context.save()
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

//#Preview {
//    UpdateSessionView(session: <#ReadingSession#>)
//}
