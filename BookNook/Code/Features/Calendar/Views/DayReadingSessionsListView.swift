import SwiftUI
import SwiftData

struct DaysReadingSessionsListView: View {
    @Binding var dateSelected: DateComponents?
    @Query(sort: [SortDescriptor(\ReadingSession.startTime, order: .reverse)]) private var sessions: [ReadingSession]
    @State var isUpdatingSession: Bool = false
    @State var selectedSession: ReadingSession?

    var filteredSessions: [ReadingSession] {
        guard let date = dateSelected?.date else { return [] }
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        return sessions.filter { $0.startTime >= startOfDay && $0.startTime < endOfDay }
    }

    var body: some View {
        NavigationStack {
            Group {
                if let _ = dateSelected?.date {
                    List(filteredSessions, id: \.id) { session in
                        ReadingSessionListViewRow(session: session)
                            .contextMenu {
                                Button("Edit Session") {
                                    selectedSession = session
                                    isUpdatingSession = true
                                }
                                Button(role: .destructive) {
                                    deleteSession(session)
                                } label: {
                                    Text("Delete Session")
                                }
                            }

                            .sheet(isPresented: $isUpdatingSession) {
                                UpdateReadingSessionView(session: session)
                            }
                    }
                    Spacer()
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
        guard let date = dateSelected?.date else { return 0 }
        let startOfDay = calendar.startOfDay(for: date)
        
        let todaySessions = filteredSessions.filter { session in
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
