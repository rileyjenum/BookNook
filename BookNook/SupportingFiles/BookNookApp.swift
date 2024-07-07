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

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
        .modelContainer(for: [ReadingSession.self, Book.self])
    }
}
