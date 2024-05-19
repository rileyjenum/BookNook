//
//  AudioPlayerView.swift
//  BookNook
//
//  Created by Riley Jenum on 18/05/24.
//
import SwiftUI

struct AudioPlayerView: View {
    @State private var isExpanded = false
    @StateObject private var audioPlayer = AudioPlayer()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                ZStack(alignment: .bottomTrailing) {
                    if isExpanded {
                        expandedView
                            .background(Color.clear)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                    } else {
                        collapsedView
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                            .transition(.move(edge: .bottom))
                            .zIndex(0)
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isExpanded)
            }
        }
    }
    
    private var collapsedView: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: "music.note")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            )
            .shadow(radius: 5)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
    }
    
    private var expandedView: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(audioPlayer.currentSongName)
                        .font(.headline.bold())
                    Text(audioPlayer.currentArtistName) // Display the artist name
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.bottom, 8)
            
            VStack {
                Slider(
                    value: Binding(
                        get: { audioPlayer.currentTime },
                        set: { audioPlayer.scrub(to: $0) }
                    ),
                    in: 0...audioPlayer.duration,
                    onEditingChanged: { editing in
                        if editing {
                            audioPlayer.scrubbing = true
                            audioPlayer.pause()
                        } else {
                            audioPlayer.scrubbing = false
                            audioPlayer.resume()
                        }
                    }
                )
                .accentColor(.gray) // Change the played portion color to gray
                .foregroundColor(.secondary) // Change the remaining portion color to lighter gray
                .frame(height: 10) // Adjust the slider height if needed
                .padding(.horizontal) // Add padding to avoid clipping

                HStack {
                    Text(timeString(time: audioPlayer.currentTime))
                    Spacer()
                    Text(timeString(time: audioPlayer.duration))
                }
            }
            .padding(.bottom, 20)
            
            HStack {
                HStack(spacing: 28) {
                    Button(action: {
                        audioPlayer.toggleShuffle()
                    }) {
                        Image(systemName: "shuffle")
                    }
                    
                    Button(action: {
                        audioPlayer.skipBackward()
                    }) {
                        Image(systemName: "backward.fill")
                    }
                    
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.pause()
                        } else if audioPlayer.player != nil && audioPlayer.player!.currentTime > 0 {
                            audioPlayer.resume()
                        } else {
                            audioPlayer.play()
                        }
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    }
                }
                .foregroundStyle(.secondary)
                .font(.title)
                                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        audioPlayer.skipForward()
                    }) {
                        Image(systemName: "forward.fill")
                    }
                    
                    Spacer()
                }
                .padding(.trailing, 50)
                .foregroundStyle(.secondary)
                .font(.title)
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: "chevron.down.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView()
    }
}
