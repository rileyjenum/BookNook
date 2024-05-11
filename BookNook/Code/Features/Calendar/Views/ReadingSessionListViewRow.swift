//
//  ReadingSessionListViewRow.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//

import Foundation
import SwiftUI

struct ReadingSessionListViewRow: View {
    let session: ReadingSession
//    @Binding var formType: ReadingSessionFormType?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.bookTitle)
                    .font(.headline)
                Text(session.author)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(formatDuration(minutes: session.duration))
                Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.subheadline)
        }
        .contentShape(Rectangle()) // Ensures the tap gesture covers the entire area of the HStack
//        .onTapGesture {
//            formType = .update(session)
//        }
    }
}

func formatDuration(minutes: Double) -> String {
    let hours = Int(minutes / 60) // Convert minutes to whole hours
    let remainingMinutes = Int(minutes) % 60 // Get remaining minutes as an integer
    return "\(hours) hour\(hours != 1 ? "s" : "") and \(remainingMinutes) minute\(remainingMinutes != 1 ? "s" : "")"
}

struct ReadingSessionListViewRow_Previews: PreviewProvider {
    static let session = ReadingSession(id: UUID().uuidString, startTime: Date(), duration: 3600, bookTitle: "War and Peace", author: "Leo Tolstoy", notes: "Captivating narrative")
    static var previews: some View {
        ReadingSessionListViewRow(session: session)
    }
}
