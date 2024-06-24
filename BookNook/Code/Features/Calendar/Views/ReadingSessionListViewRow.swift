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
                Text("Start time: \(session.startTime, formatter: DateFormatter.shortTime)")
                Text("Duration: \(formatDuration(session.duration))")
                Text("Pages read: \(session.pagesRead)")

            }
            .font(.subheadline)
        }
        .contentShape(Rectangle()) // Ensures the tap gesture covers the entire area of the HStack
    }
}

// Utility function to format duration from seconds to readable format
func formatDuration(_ duration: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: duration) ?? "0 sec"
}

// Update the preview provider to reflect changes
struct ReadingSessionListViewRow_Previews: PreviewProvider {
    static let book = Book(title: "War and Peace", author: "Leo Tolstoy")
    static let session = ReadingSession(startTime: Date(), duration: 3600, book: book, notes: "Captivating narrative", pagesRead: 1)
    
    static var previews: some View {
        ReadingSessionListViewRow(session: session)
    }
}
