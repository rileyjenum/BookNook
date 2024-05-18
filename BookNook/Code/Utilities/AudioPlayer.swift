//
//  AudioPlayer.swift
//  BookNook
//
//  Created by Riley Jenum on 18/05/24.
//
import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    private var audioFiles: [String] = []
    private var shuffledFiles: [String] = []
    private var currentIndex: Int = 0
    var isShuffled: Bool = false
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var volume: Float = 0.5 {
        didSet {
            player?.volume = volume
        }
    }
    @Published var currentSongName: String = ""
    @Published var scrubbing = false

    override init() {
        super.init()
        loadAudioFiles()
    }

    private func loadAudioFiles() {
        // Replace with the actual names of your audio files
        audioFiles = ["Sonder(chosic.com)", "Colorful-Flowers(chosic.com)"]
        shuffledFiles = audioFiles.shuffled()
    }

    private var currentPlaylist: [String] {
        return isShuffled ? shuffledFiles : audioFiles
    }

    func play() {
        guard !currentPlaylist.isEmpty else { return }
        let soundName = currentPlaylist[currentIndex]
        currentSongName = soundName
        if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.volume = volume
                player?.delegate = self
                player?.play()
                isPlaying = true
                duration = player?.duration ?? 0
                startTimer()
            } catch {
                print("Failed to play audio: \(error.localizedDescription)")
            }
        }
    }

    func resume() {
        player?.play()
        isPlaying = true
        startTimer()
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.stop()
        isPlaying = false
    }

    func skipForward() {
        if currentIndex < currentPlaylist.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        play()
    }

    func skipBackward() {
        if let player = player {
            if player.currentTime > 3 {
                player.currentTime = 0
                player.play()
            } else {
                if currentIndex > 0 {
                    currentIndex -= 1
                } else {
                    currentIndex = currentPlaylist.count - 1
                }
                play()
            }
        }
    }

    func toggleShuffle() {
        isShuffled.toggle()
        currentIndex = 0
        shuffledFiles = audioFiles.shuffled()
    }

    func scrub(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard let player = self.player, !self.scrubbing else {
                timer.invalidate()
                return
            }
            self.currentTime = player.currentTime
            if !self.isPlaying {
                timer.invalidate()
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            skipForward()
        }
    }
}
