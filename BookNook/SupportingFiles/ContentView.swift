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
//    @Query var foundSessions: [ReadingSession]
//    @Environment(\.modelContext) var context

    var body: some View {
        MainTabbedView()
//            .onAppear {
//                do {
//                    for object in foundSessions {
//                        print("deleted")
//                        context.delete(object)
//                    }
//                    try context.save()
//                } catch {
//                    print("Failed to delete all objects: \(error)")
//                }
//            }
    }
}

#Preview {
    ContentView()
}
