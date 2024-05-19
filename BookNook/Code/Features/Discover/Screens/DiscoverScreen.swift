//
//  DiscoverScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import SwiftUI
import Combine
import SwiftData

struct DiscoverScreen: View {
    @StateObject private var viewModel = BookViewModel()
    @Environment(\.modelContext) var context
    
    @State private var searchQuery: String = ""
    @State private var showAddManualBookForm: Bool = false
    @State private var showAddBookAlert: Bool = false
    @State private var selectedBook: Book?
    @State private var selectedLanguage = "en"
    @State private var sortOption = "relevance"
//    @Binding var showingSearchBook: Bool
    
    let sortOptions = ["relevance", "newest"]
    
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for books", text: $searchQuery, onCommit: {
                    viewModel.searchBooks(query: searchQuery, language: selectedLanguage, sort: sortOption)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                LanguageSelectionView(selectedLanguage: $selectedLanguage)
                Picker("Sort By", selection: $sortOption) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(option.capitalized).tag(option)
                    }
                }
                .presentationCornerRadius(1)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                List(viewModel.books, id: \.id) { book in
                    HStack {
                        if let urlString = book.coverImageUrl, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 75)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 75)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 75)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text(book.title).font(.headline)
                            Text(book.author).font(.subheadline)
                            if let bookDescription = book.bookDescription {
                                Text(bookDescription).font(.body).lineLimit(3)
                            }
                        }
                    }
                    .onTapGesture {
                        selectedBook = book
                        showAddBookAlert = true
                    }
                }
                
                Button("Add Book Manually") {
                    showAddManualBookForm.toggle()
                }
                .padding()
                .sheet(isPresented: $showAddManualBookForm) {
                    AddManualBookView(viewModel: viewModel)
                }
            }
            .navigationBarTitle("Search Books")
            .alert(isPresented: $showAddBookAlert) {
                Alert(
                    title: Text("Add Book"),
                    message: Text("Do you want to add this book to your library?"),
                    primaryButton: .default(Text("Add")) {
                        if let book = selectedBook {
                            addBookToContext(book)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func addBookToContext(_ book: Book) {
        context.insert(book)
        do {
            try context.save()
//            showingSearchBook = false // Dismiss the sheet view after adding the book
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
    }
}

struct AddManualBookView: View {
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

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String
    
    let languages = ["en", "it", "es", "fr", "de"]
    
    var body: some View {
        Picker("Select Language", selection: $selectedLanguage) {
            ForEach(languages, id: \.self) { language in
                Text(language).tag(language)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

//struct BookSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookSearchScreen(showingSearchBook: $showingSearchBook)
//            .environmentObject(TimerManager())
//    }
//}
