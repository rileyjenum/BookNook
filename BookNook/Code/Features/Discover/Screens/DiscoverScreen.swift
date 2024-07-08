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
    @State private var selectedBook: Book?
    @State private var showSearchResults = false
    @State private var activeAlert: ActiveAlert = .addBook
    
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
                    TextField("Search for books", text: $searchQuery, onCommit: {
                        viewModel.searchBooks(query: searchQuery)
                        showSearchResults = true
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(categories, id: \.self) { category in
                                Text(category.replacingOccurrences(of: "-", with: " ").capitalized)
                                    .font(.custom("Baskerville Light-Italic", size: 25))
                                    .padding(.leading)
                                    .padding([.top, .bottom], 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.nytBestsellers[category] ?? []) { book in
                                            BookCoverView(book: book)
                                                .onTapGesture {
                                                    selectedBook = book
                                                    activeAlert = .addBook
                                                    showAlert = true
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 200)
                            }
                        }
                    }
                }
                .navigationBarTitle("Discover Books")
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .addBook:
                        return Alert(
                            title: Text("Add Book"),
                            message: Text("Do you want to add this book to your library?"),
                            primaryButton: .default(Text("Add")) {
                                if let book = selectedBook {
                                    if bookTitles.contains(book.title) {
                                        showAlert = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            activeAlert = .error
                                            showAlert = true
                                        }
                                    } else {
                                        addBookToContext(book)
                                        showAlert = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            activeAlert = .success
                                            showAlert = true
                                        }
                                    }
                                }
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
            }
            
            if showSearchResults {
                VStack {
                    TextField("Search for books", text: $searchQuery, onCommit: {
                        viewModel.searchBooks(query: searchQuery)
                        showSearchResults = true
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    List(viewModel.books, id: \.id) { book in
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
                            selectedBook = book
                            activeAlert = .addBook
                            showAlert = true
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)
                }
                .background(
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showSearchResults = false
                        }
                )
                .transition(.move(edge: .top))
            }
        }
    }
    
    private func addBookToContext(_ book: Book) {
        context.insert(book)
        do {
            try context.save()
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
    }
}
