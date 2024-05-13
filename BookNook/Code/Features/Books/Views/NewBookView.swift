//
//  NewBookView.swift
//  BookNook
//
//  Created by Riley Jenum on 13/05/24.
//

import SwiftUI
import SwiftData

struct NewBookView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query private var books: [Book]

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                Button("Save Book") {
                    saveBook()
                }
            }
            .navigationTitle("Add New Book")
            .toolbar {
                Button("Cancel") {
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

    private func saveBook() {
        if title.isEmpty || author.isEmpty {
            errorMessage = "Please ensure all fields are filled in."
            showError = true
            return
        }

        if isDuplicateTitle() {
            errorMessage = "A book with this title already exists. Please use a different title."
            showError = true
            return
        }

        let newBook = Book(title: title, author: author)
        context.insert(newBook)
        try? context.save()  // Assume this commits the transaction
        dismiss()
    }

    private func isDuplicateTitle() -> Bool {
        books.contains { $0.title.lowercased() == title.lowercased() }
    }

}

