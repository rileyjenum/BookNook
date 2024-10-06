//
//  LibraryCardView.swift
//  BookNook
//
//  Created by Riley Jenum on 26/09/24.
//

import SwiftUI
import SwiftData

struct LibraryCardView: View {
    
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var allSessions: [ReadingSession]
    
    @Binding var selectedBook: Book?
    
    @Binding var isBookOpen: Bool

    let colors = [
        Color(red: 0.75, green: 0.72, blue: 0.65),
        Color(red: 0.95, green: 0.92, blue: 0.85)
    ]
    
    let geometry: GeometryProxy
    
    @State private var areSessionsExpanded = false
    
    var filteredSessions: [ReadingSession] {
        allSessions.filter { $0.book.id == selectedBook?.id }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Library Card")
                    .font(.custom("Clarendon Regular", size: 30))
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()
                    .frame(height: 2)
                    .overlay(Color.black.opacity(0.5))
                HStack {
                    Text("Title")
                        .font(.custom("Clarendon Regular", size: 20))
                        .padding()
                    Text(selectedBook?.title ?? "")
                        .font(.custom("blzee", size: 30))
                        .padding()
                    
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black.opacity(0.4))
                
                HStack {
                    Text("Author")
                        .font(.custom("Clarendon Regular", size: 20))
                        .padding()
                    Text(selectedBook?.author ?? "")
                        .font(.custom("blzee", size: 30))
                        .padding()
                    
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black.opacity(0.7))
                
                
                HStack {
                    Text("Description")
                        .font(.custom("Clarendon Regular", size: 20))
                        .padding()
                    Text(selectedBook?.bookDescription ?? "")
                        .font(.custom("blzee", size: 10))
                        .padding()
                    
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black.opacity(0.7))
                
                
                HStack {
                    Text("Sessions")
                        .font(.custom("Clarendon Regular", size: 20))
                        .padding()
                    
                    Divider()
                        .frame(width: 1)
                        .overlay(Color.black.opacity(0.7))
                        .padding(.bottom, 5)
                    
                    Button(action: {
                        withAnimation {
                            isBookOpen.toggle()
                        }
                    }, label: {
                        Text("Start reading")
                            .foregroundStyle(.black)
                    })
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            areSessionsExpanded.toggle()

                        }
                    }) {
                        Image(systemName: areSessionsExpanded ? "chevron.up" : "chevron.down")
                            .padding()
                            .foregroundStyle(.black)
                    }
                }
                
                if areSessionsExpanded {
                    ForEach(filteredSessions) { session in
                        VStack {
                            Divider()
                                .frame(height: 1)
                                .overlay(Color.black.opacity(0.4))
                            
                            Text("Session: \(session.startTime, formatter: DateFormatter.shortTime)")
                                .font(.custom("Clarendon Regular", size: 18))
                                .padding(.horizontal)
                            
                            Text("Pages read: \(session.pagesRead)")
                                .font(.custom("Clarendon Regular", size: 16))
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(3)
        .shadow(color: Color.black.opacity(0.25), radius: 10)
        .padding(.horizontal)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
     return GeometryReader { geo in
        ZStack(alignment: .center) {
            Color.white.ignoresSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height: 160)
                    LibraryCardView(selectedBook: .constant(Book(title: "Harry Potter", author: "J.K. Rowling",bookDescription: "Book description", category: .currentlyReading)), isBookOpen: .constant(false), geometry: geo)
                }
            }
        }
    }
     .modelContainer(container)
}