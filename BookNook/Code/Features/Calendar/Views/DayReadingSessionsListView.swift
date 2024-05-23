import SwiftUI
import SwiftData

struct DaysReadingSessionsListView: View {
    @Binding var dateSelected: DateComponents?
    @Query private var foundSessions: [ReadingSession]
    @State var isUpdatingSession: Bool = false

    init(dateSelected: Binding<DateComponents?>) {
        self._dateSelected = dateSelected
        
        // Setup _foundSessions with dynamic query
        if let date = dateSelected.wrappedValue?.date {
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

            _foundSessions = Query(
                filter: #Predicate<ReadingSession> { session in
                    session.startTime >= startOfDay && session.startTime < endOfDay
                },
                sort: [SortDescriptor(\ReadingSession.startTime, order: .reverse)]
            )
        } else {
            _foundSessions = Query(filter: #Predicate<ReadingSession> { _ in false })
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if let _ = dateSelected?.date {
                    List(foundSessions, id: \.self) { session in
                        ReadingSessionListViewRow(session: session)
                            .onTapGesture {
                                isUpdatingSession = true
                            }
                            .sheet(isPresented: $isUpdatingSession) {
                                UpdateReadingSessionView(session: session)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteSession(session)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                    Text("Day's Reading Time: \(formattedTime(totalReadingTimeToday()))")

                } else {
                    Text("No sessions found for the selected date.")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle(dateSelected?.date?.formatted(date: .long, time: .omitted) ?? "Select a Date")
        }
    }

    private func deleteSession(_ session: ReadingSession) {
        if let context = session.modelContext {
            context.delete(session)
        }
    }
    
    private func totalReadingTimeToday() -> TimeInterval {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())

        let todaySessions = foundSessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: startOfDay)
        }

        return todaySessions.reduce(0) { $0 + $1.duration }
    }
    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct DaysReadingSessionsListView_Previews: PreviewProvider {
    static var previews: some View {
        DaysReadingSessionsListView(dateSelected: .constant(Calendar.current.dateComponents([.year, .month, .day], from: Date())))
    }
}
