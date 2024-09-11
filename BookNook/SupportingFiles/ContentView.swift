//
//  ContentView.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import SwiftData

import SplineRuntime
import SwiftUI

struct ContentView: View {
    @Query var foundSessions: [ReadingSession]
    @Query var foundBooks: [Book]
    @Environment(\.modelContext) var context
    
    var body: some View {
        MainTabbedView()
            .environmentObject(TimerManager())
        
            .onAppear {
                do {
                    for session in foundSessions {
                        print(session)
                                                context.delete(session)
                        
                    }
                    for book in foundBooks {
                                                context.delete(book)
                        print(book)
                    }
                    try context.save()
                } catch {
                    print("Failed to delete all objects: \(error)")
                }
            }
        
        
            .onAppear(perform: {
                for i in 1...20 {
                    context.insert(Book(title: "Currently Reading Book \(i)", author: "Author \(i)", category: .currentlyReading))
                    context.insert(Book(title: "Have Read Book \(i)", author: "Author \(i)", category: .haveRead))
                    context.insert(Book(title: "Will Read Book \(i)", author: "Author \(i)", category: .willRead))
                }
                try? context.save()
            })
    }
}

#Preview {
    ContentView()
}
