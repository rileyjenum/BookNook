//
//  DiscoverScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct DiscoverScreen: View {
    
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    
    @Environment(\.modelContext) var context
    
    @StateObject private var viewModel = DiscoverScreenViewModel.shared
    
    @State private var searchQuery: String = ""
    @State private var showAlert: Bool = false
    @State private var showCategorySheet: Bool = false
    @State private var selectedBook: Book?
    @State private var showSearchResults = false
    @State private var activeAlert: ActiveAlert = .addBook
    @State private var selectedCategory: BookCategory = .willRead
    @State private var bookCategories: [BookCategory] = [.willRead, .haveRead, .currentlyReading]

    
    var bookTitles: [String] {
        books.map { $0.title }
    }
    
    enum ActiveAlert {
        case addBook, error, success
    }
    
    let categories = ["young-adult-hardcover", "hardcover-fiction", "hardcover-nonfiction"]
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    SearchBar(text: $searchQuery, onSearchButtonClicked: {
                        viewModel.searchBooks(query: searchQuery)
                        withAnimation {
                            showSearchResults = true
                        }
                    })
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(categories, id: \.self) { category in
                                VStack(alignment: .leading) {
                                    Text(category.replacingOccurrences(of: "-", with: " ").capitalized)
                                        .font(.custom("Baskerville-Italic", size: 25))
                                        .padding(.leading)
                                        .padding(.top, 20)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(viewModel.nytBestsellers[category] ?? []) { book in
                                                BookCoverView(book: book)
                                                    .onTapGesture {
                                                        selectedBook = book
                                                        activeAlert = .addBook
                                                        showAlert = true
                                                    }
                                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                                    .scaleEffect(1.0)
                                                    .animation(.easeInOut)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .frame(height: 200)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                .navigationBarTitle("Discover Books", displayMode: .large)
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .addBook:
                        return Alert(
                            title: Text("Add Book"),
                            message: Text("Do you want to add this book to your library?"),
                            primaryButton: .default(Text("Select Category")) {
                                showAlert = false
                                showCategorySheet = true
                            },
                            secondaryButton: .cancel()
                        )
                        
                    case .error:
                        return Alert(
                            title: Text("Error"),
                            message: Text("This book is already in your library"),
                            dismissButton: .default(Text("OK"))
                        )
                    case .success:
                        return Alert(
                            title: Text("Success"),
                            message: Text("This book was successfully added to your library"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .actionSheet(isPresented: $showCategorySheet) {
                    ActionSheet(
                        title: Text("Select Category"),
                        message: Text("Choose a category to add the book to."),
                        buttons: bookCategories.map { category in
                                .default(Text(category.rawValue)) {
                                selectedCategory = category
                                if let book = selectedBook {
                                    if bookTitles.contains(book.title) {
                                        activeAlert = .error
                                        showAlert = true
                                    } else {
                                        addBookToContext(book, category: selectedCategory)
                                        activeAlert = .success
                                        showAlert = true
                                    }
                                }
                            }
                        } + [.cancel()]
                    )
                }
            }
            
            if showSearchResults {
                SearchResultsView(
                    searchQuery: $searchQuery,
                    books: viewModel.books,
                    onSelectBook: { book in
                        selectedBook = book
                        activeAlert = .addBook
                        showAlert = true
                    },
                    onClose: {
                        withAnimation {
                            showSearchResults = false
                        }
                    }
                )
            }
        }
    }
    
    private func addBookToContext(_ book: Book, category: BookCategory) {
        book.category = category
        context.insert(book)
        do {
            try context.save()
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search for books", text: $text, onCommit: onSearchButtonClicked)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .shadow(radius: 5)
            
            Button(action: onSearchButtonClicked) {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
        }
        .padding(.horizontal)
    }
}

struct SearchResultsView: View {
    @Binding var searchQuery: String
    var books: [Book]
    var onSelectBook: (Book) -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack {
            SearchBar(text: $searchQuery, onSearchButtonClicked: {})
                .padding()
            
            List(books, id: \.id) { book in
                HStack {
                    if let urlString = book.coverImageUrl, let url = URL(string: urlString) {
                        WebImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 100, height: 150)
                                .foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 150)
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
                    onSelectBook(book)
                }
                .padding(.vertical, 5)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            .listStyle(PlainListStyle())
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .shadow(radius: 10)
        }
        .background(
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onClose()
                }
        )
        .transition(.move(edge: .top))
    }
}

struct DiscoverScreen_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverScreen()
    }
}
