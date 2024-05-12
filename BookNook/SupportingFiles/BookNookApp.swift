//
//  BookNookApp.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import SwiftData

@main
struct BookNookApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            ReadingSession.self,
//            Book.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ReadingSession.self, Book.self])
    }
}
