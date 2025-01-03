//
//  BookDetailView.swift
//  BookNook
//
//  Created by Riley Jenum on 06/06/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct BookDetailView: View {
    
    var book: Book
    var sessions: [ReadingSession]
    
    @State var isEditingSession: Bool = false
    @State var selectedSession: ReadingSession?
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        VStack {
            if let coverImageUrl = book.coverImageUrl, let url = URL(string: coverImageUrl) {
                
                WebImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                    
                } placeholder: {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 150, height: 225)
                        .foregroundColor(.gray)
                }
                .onSuccess { image, data, cacheType in
                    // Success
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
                .frame(width: 150, height: 225)
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: 150, height: 225)
                    .cornerRadius(3)
                    .shadow(radius: 4)
                    .padding()
                Text(book.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
            }
            
            Text(book.title)
                .font(.largeTitle)
                .padding()
            Text("\(String(describing: book.pagesRead))")
            
            List {
                ForEach(groupSessionsByDay(), id: \.0) { (day, sessions) in
                    Section(header: Text(day)) {
                        ForEach(sessions, id: \.id) { session in
                            SessionView(session: session)
                                .contextMenu {
                                    Button("Edit Session") {
                                        selectedSession = session
                                        isEditingSession = true
                                    }
                                    Button(role: .destructive) {
                                        deleteSession(session: session)
                                    } label: {
                                        Text("Delete Session")
                                    }
                                }
                        }
                        .onDelete { offsets in
                            deleteSessions(sessions: sessions, at: offsets)
                        }
                    }
                }
            }
            
            .sheet(item: $selectedSession) { session in
                UpdateReadingSessionView(session: session)
            }
            
            Text("Book Reading Time: \(formattedTime(totalBookReadingTime()))")
                .padding()
        }
    }
    
    func groupSessionsByDay() -> [(String, [ReadingSession])] {
        let calendar = Calendar.current
        let groupedSessions = Dictionary(grouping: sessions.sorted(by: { $0.startTime > $1.startTime })) { session in
            let date = session.startTime
            return calendar.startOfDay(for: date)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return groupedSessions.map { (date, sessions) in
            (dateFormatter.string(from: date), sessions)
        }
        .sorted(by: { $0.0 > $1.0 }) // Sort by day string in descending order
    }
    
    func deleteSessions(sessions: [ReadingSession], at offsets: IndexSet) {
        for index in offsets {
            let session = sessions[index]
            deleteSession(session: session)
        }
    }
    
    func deleteSession(session: ReadingSession) {
        context.delete(session)
        do {
            try context.save()
        } catch {
            print("Failed to delete session: \(error.localizedDescription)")
        }
    }
    
    private func totalBookReadingTime() -> TimeInterval {
        let bookSessions = sessions.filter { $0.book.id == book.id }
        return bookSessions.reduce(0) { $0 + $1.duration }
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SessionView: View {
    @Bindable var session: ReadingSession
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Session on \(session.startTime, formatter: Formatter.item)")
            Text("Duration: \(session.duration) seconds")
            Text("Notes: \(session.notes)")
        }
        .padding()
    }
}

struct Formatter {
    static let item: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}
