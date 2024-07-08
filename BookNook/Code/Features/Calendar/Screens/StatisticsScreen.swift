//
//  StatisticsScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 23/06/24.
//

import Foundation
import SwiftUI
import Charts
import SwiftData

struct StatisticsScreen: View {
    
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]

    var totalReadingTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    var totalPagesRead: Int {
        sessions.reduce(0) { $0 + $1.pagesRead }
    }

    var averageReadingTimePerSession: TimeInterval {
        guard !sessions.isEmpty else { return 0 }
        return totalReadingTime / TimeInterval(sessions.count)
    }

    var averagePagesReadPerSession: Int {
        guard !sessions.isEmpty else { return 0 }
        return totalPagesRead / sessions.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Reading Statistics")
                    .font(.largeTitle)
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Reading Time: \(totalReadingTime.formatted()) seconds")
                    Text("Total Pages Read: \(totalPagesRead)")
                    Text("Average Reading Time per Session: \(averageReadingTimePerSession.formatted()) seconds")
                    Text("Average Pages Read per Session: \(averagePagesReadPerSession)")
                }
                .padding()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Reading Time Over Time")
                        .font(.headline)
                    ReadingTimeChart(sessions: sessions)
                        .frame(height: 300)
                        .padding()

                    Text("Pages Read Over Time")
                        .font(.headline)
                    PagesReadChart(sessions: sessions)
                        .frame(height: 300)
                        .padding()

                    Text("Pages Read per Book")
                        .font(.headline)
                    BooksReadChart(books: books)
                        .frame(height: 300)
                        .padding()
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

struct ReadingTimeChart: View {
    let sessions: [ReadingSession]

    var body: some View {
        let data = sessions.map { session in
            (session.startTime, session.duration)
        }
        
        return Chart {
            ForEach(data, id: \.0) { date, duration in
                LineMark(
                    x: .value("Date", date),
                    y: .value("Reading Time (seconds)", duration)
                )
            }
        }
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXAxisLabel("Date")
        .chartYAxisLabel("Reading Time (seconds)")
    }
}

struct PagesReadChart: View {
    let sessions: [ReadingSession]

    var body: some View {
        let data = sessions.map { session in
            (session.startTime, session.pagesRead)
        }
        
        return Chart {
            ForEach(data, id: \.0) { date, pagesRead in
                BarMark(
                    x: .value("Date", date),
                    y: .value("Pages Read", pagesRead)
                )
            }
        }
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: true))
        .chartXAxisLabel("Date")
        .chartYAxisLabel("Pages Read")
    }
}

struct BooksReadChart: View {
    let books: [Book]

    var body: some View {
        let data = books.map { book in
            (book.title, book.pagesRead ?? 0)
        }
        
        return Chart {
            ForEach(data, id: \.0) { title, pagesRead in
                BarMark(
                    x: .value("Book Title", title),
                    y: .value("Pages Read", pagesRead)
                )
            }
        }
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: true))
        .chartXAxisLabel("Book Title")
        .chartYAxisLabel("Pages Read")
    }
}

struct StatisticsScreen_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsScreen()
    }
}
