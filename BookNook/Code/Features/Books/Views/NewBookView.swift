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
    @ObservedObject var viewModel: BookViewModel
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var bookDescription: String = ""
    @State private var publisher: String = ""
    @State private var publishedDate: String = ""
    @State private var pageCount: String = ""
    @State private var categories: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    TextField("Description", text: $bookDescription)
                    TextField("Publisher", text: $publisher)
                    TextField("Published Date", text: $publishedDate)
                    TextField("Page Count", text: $pageCount)
                    TextField("Categories", text: $categories)
                }
                
                Button("Add Book") {
                    if title.isEmpty || author.isEmpty {
                        showError = true
                        errorMessage = "Title and Author are required fields."
                    } else {
                        saveBook()
                    }
                }
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add Book Manually", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveBook() {
        let book = Book(
            title: title,
            author: author,
            bookDescription: bookDescription,
            publisher: publisher,
            publishedDate: publishedDate,
            pageCount: Int(pageCount),
            categories: categories.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        )
        
        context.insert(book)
        
        do {
            try context.save()
            dismiss()
        } catch {
            showError = true
            errorMessage = "Failed to save book: \(error.localizedDescription)"
        }
    }
}

