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
    var timer: Timer?

    func startTimer(duration: TimeInterval) {
        remainingTime = duration
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

    func stopTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
    }
}
