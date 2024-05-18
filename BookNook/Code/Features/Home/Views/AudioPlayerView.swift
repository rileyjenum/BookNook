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
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .background(Color.white)
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
            VStack(spacing: 20) {
                Text(audioPlayer.currentSongName)
                    .font(.title)
                    .padding()
                
                HStack {
                    Text(timeString(time: audioPlayer.currentTime))
                    Spacer()
                    Text(timeString(time: audioPlayer.duration))
                }
                
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
                
                HStack {
                    Button(action: {
                        audioPlayer.skipBackward()
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.largeTitle)
                            .padding()
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
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    Button(action: {
                        audioPlayer.skipForward()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.largeTitle)
                            .padding()
                    }
                }
                
                Button(action: {
                    audioPlayer.toggleShuffle()
                }) {
                    HStack {
                        Image(systemName: "shuffle")
                            .font(.title)
                        Text(audioPlayer.isShuffled ? "Unshuffle" : "Shuffle")
                            .font(.title2)
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.top)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: "chevron.down.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
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
