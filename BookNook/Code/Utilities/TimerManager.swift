//
//  TimerManager.swift
//  BookNook
//
//  Created by Riley Jenum on 13/05/24.
//

import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var isActive: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var showStopAlert: Bool = false
    var timer: Timer?
    var sessionStartTime: Date?
    var currentSession: ReadingSession?

    func startTimer(session: ReadingSession) {
        self.currentSession = session
        sessionStartTime = Date()
        elapsedTime = 0
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
        }
    }

    func requestStopTimer() {
        self.showStopAlert = true
    }

    func stopTimer() {
        DispatchQueue.main.async {
            self.showStopAlert = false
            self.isActive = false
            self.timer?.invalidate()
            self.timer = nil
            if let startTime = self.sessionStartTime, let session = self.currentSession {
                let actualDuration = Date().timeIntervalSince(startTime)
                session.duration = actualDuration
            }
            self.sessionStartTime = nil
        }
    }

    func completeSession() {
        self.currentSession = nil
    }
}
