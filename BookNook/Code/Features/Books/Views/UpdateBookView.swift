//
//  UpdateBookView.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct UpdateBookView: View {
    @Bindable var book: Book
    @Environment(\.dismiss) var dismiss

    var isFormIncomplete: Bool {
        book.title.isEmpty || book.author.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Title", text: $book.title)
                    TextField("Author", text: $book.author)
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
            .navigationTitle("Update Book")
        }
    }
}
