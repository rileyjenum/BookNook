//
//  CalendarView.swift
//  BookNook
//
//  Created by Riley Jenum on 11/05/24.
//

import SwiftUI
import SwiftData

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    @Binding var dateSelected: DateComponents?
    @Binding var displaySessions: Bool

    func makeUIView(context: Context) -> some UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        let calendar = Calendar.current
        let dateComponentsNeeded: Set<Calendar.Component> = [.year, .month, .day]
        let uniqueDates = Set(sessions.map { calendar.dateComponents(dateComponentsNeeded, from: $0.startTime) })
        uiView.reloadDecorations(forDateComponents: Array(uniqueDates), animated: true)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        
        init(parent: CalendarView) {
            self.parent = parent
        }

        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundSessions = parent.sessions
                .filter { Calendar.current.isDate($0.startTime, inSameDayAs: dateComponents.date!) }

            if foundSessions.isEmpty { return nil }

            return .customView {
                let icon = UILabel()
                switch foundSessions.count {
                case 0:
                    icon.text = ""
                case 1:
                    icon.text = "📘"
                default:
                    icon.text = "📚"
                }
                return icon
            }
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
            guard let dateComponents = dateComponents else { return }
            let foundSessions = parent.sessions
                .filter { Calendar.current.isDate($0.startTime, inSameDayAs: dateComponents.date!) }
            parent.displaySessions = !foundSessions.isEmpty
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
}
