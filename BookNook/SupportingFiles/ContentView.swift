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
            .onAppear {
                do {
                    for object in foundSessions {
                        print("deleted")
                        context.delete(object)
                        for book in foundBooks {
                            context.delete(book)

                        }
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
