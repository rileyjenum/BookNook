//
//  DiscoverScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 14/05/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverScreen: View {
    @StateObject private var viewModel = BookViewModel()
    @Environment(\.modelContext) var context
    
    @State private var searchQuery: String = ""
    @State private var showAddBookAlert: Bool = false
    @State private var selectedBook: Book?
    @State private var showSearchResults = false
    
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
                                    .font(.headline)
                                    .padding(.leading)
                                    .padding([.top, .bottom], 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.nytBestsellers[category] ?? []) { book in
                                            BookCoverView(book: book)
                                                .onTapGesture {
                                                    selectedBook = book
                                                    showAddBookAlert = true
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
                .onAppear {
                    for category in categories {
                        viewModel.fetchBestsellers(for: category)
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
                            showAddBookAlert = true
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



//struct BookSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookSearchScreen(showingSearchBook: $showingSearchBook)
//            .environmentObject(TimerManager())
//    }
//}
