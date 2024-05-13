//
//  NewBookView.swift
//  BookNook
//
//  Created by Riley Jenum on 13/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct NewBookView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var showError: Bool = false

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
                      message: Text("Please ensure all fields are filled in."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveBook() {
        if title.isEmpty || author.isEmpty {
            showError = true
            return
        }
        let newBook = Book(title: title, author: author)
        context.insert(newBook)
        // Assuming there is a save or commit method to finalize changes
        try? context.save() // Example: adjust according to your data handling
        dismiss()
    }
}
