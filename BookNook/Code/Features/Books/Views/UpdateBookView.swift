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
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false

    var isFormIncomplete: Bool {
        book.title.isEmpty || book.author.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Title", text: $book.title)
                    TextField("Author", text: $book.author)
                    TextField("Description", text: Binding($book.bookDescription, default: ""))
                    TextField("Publisher", text: Binding($book.publisher, default: ""))
                    TextField("Published Date", text: Binding($book.publishedDate, default: ""))
                    TextField("Page Count", value: $book.pageCount, formatter: NumberFormatter())
                    TextField("Categories", text: Binding(
                        get: {
                            book.categories?.joined(separator: ", ") ?? ""
                        },
                        set: { newValue in
                            book.categories = newValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        }
                    ))
                    TextField("Cover Image URL", text: Binding($book.coverImageUrl, default: ""))

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    Button("Select Cover Image") {
                        isPickerPresented.toggle()
                    }
                    .sheet(isPresented: $isPickerPresented) {
                        PhotoPicker(image: $selectedImage)
                    }

                    Section(footer:
                                HStack {
                        Spacer()
                        Button("Update") {
                            if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                                // You can upload the imageData to your server and get a URL for the image
                                // For now, we'll just simulate setting a cover image URL
                                book.coverImageUrl = "URL of the uploaded image"
                            }
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
            .navigationTitle("Update Book")
        }
    }
}

extension Binding {
    init<T>(_ source: Binding<T?>, default defaultValue: T) where Value == T {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
