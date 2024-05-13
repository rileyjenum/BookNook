//
//  ReadingSessionListViewRow.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//

import SwiftUI

struct ReadingSessionListViewRow: View {
    let session: ReadingSession

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.book.title)  // Updated to use the Book relationship
                    .font(.headline)
                Text(session.book.author)  // Updated to use the Book relationship
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(formatDuration(minutes: session.duration))
                Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.subheadline)
        }
        .contentShape(Rectangle()) // Ensures the tap gesture covers the entire area of the HStack
    }
}

func formatDuration(minutes: Double) -> String {
    let hours = Int(minutes / 60) // Convert minutes to whole hours
    let remainingMinutes = Int(minutes) % 60 // Get remaining minutes as an integer
    return "\(hours) hour\(hours != 1 ? "s" : "") and \(remainingMinutes) minute\(remainingMinutes != 1 ? "s" : "")"
}

// Update the preview provider to reflect changes
struct ReadingSessionListViewRow_Previews: PreviewProvider {
    static let book = Book(title: "War and Peace", author: "Leo Tolstoy")
    static let session = ReadingSession(startTime: Date(), duration: 3600, book: book, notes: "Captivating narrative")
    
    static var previews: some View {
        ReadingSessionListViewRow(session: session)
    }
}
