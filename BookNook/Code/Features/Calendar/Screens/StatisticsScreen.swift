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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Reading Statistics")
                    .font(.largeTitle)
                    .padding()

                ReadingTimeChart(sessions: sessions)
                    .frame(height: 300)
                    .padding()

                // Add more charts and statistics here
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
                    y: .value("Reading Time", duration)
                )
            }
        }
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: false))
    }
}

struct StatisticsScreen_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsScreen()
    }
}
