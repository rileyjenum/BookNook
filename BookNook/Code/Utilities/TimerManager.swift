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
    @Published var remainingTime: TimeInterval = 0
    @Published var showStopAlert: Bool = false
    var timer: Timer?
    var sessionStartTime: Date?
    var currentSession: ReadingSession?

    func startTimer(session: ReadingSession) {
        self.currentSession = session
        sessionStartTime = Date() // Store the start time when the timer starts
        remainingTime = session.duration
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
            }
        }
    }

    func requestStopTimer() {
        showStopAlert = true
    }

    func stopTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        if let startTime = sessionStartTime, let session = currentSession {
            let actualDuration = Date().timeIntervalSince(startTime)
            session.duration = actualDuration
        }
        currentSession = nil
        sessionStartTime = nil
    }
}

