//
//  CalendarScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//
import Foundation
import SwiftUI

struct CalendarScreen: View {
    @State private var dateSelected: DateComponents?
    @State private var displaySessions = false
    @State private var isPresentingNewSessionForm = false // New state for form presentation
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture),
                                 dateSelected: $dateSelected,
                                 displaySessions: $displaySessions)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 10)
                    )
                    .padding()
                }
                .navigationTitle("Calendar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isPresentingNewSessionForm = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                                .shadow(radius: 5)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: StatisticsScreen()) {
                            Image(systemName: "chart.bar.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                                .shadow(radius: 5)
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewSessionForm) {
                NewReadingSessionView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $displaySessions) {
                DaysReadingSessionsListView(dateSelected: $dateSelected)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct CalendarScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScreen()
    }
}
