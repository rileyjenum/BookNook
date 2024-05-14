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
                    for object in foundSessions {
                        print(object)
//                        context.delete(object)

                    }
                    for book in foundBooks {
//                        context.delete(book)
                        print(book)
                    }
                    try context.save()
                } catch {
                    print("Failed to delete all objects: \(error)")
                }
            }
    }
}

#Preview {
    ContentView()
}
