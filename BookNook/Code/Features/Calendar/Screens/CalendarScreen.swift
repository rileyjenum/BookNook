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
            ScrollView {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture),
                                           dateSelected: $dateSelected,
                                           displaySessions: $displaySessions)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingNewSessionForm = true // Trigger form presentation
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewSessionForm) { // Present the form as a sheet
                ReadingSessionFormView() // Assuming this form view can handle creating new sessions
            }
            .sheet(isPresented: $displaySessions) {
                DaysReadingSessionsListView(dateSelected: $dateSelected)
                    .presentationDetents([.medium, .large])
            }
            .navigationTitle("Calendar")
        }
    }
}

struct CalendarScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScreen()
    }
}

