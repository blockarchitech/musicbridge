//
//  ContentView.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import SwiftUI



struct ContentView: View {
    
    var body: some View {
        VStack {
            
            Image(systemName: "music.note")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("musicbridge")
                .font(.system(size: 20))
                .bold()
            Text("MIDI to AppleScript converter")
            Text("Using input:")
            Button(action: spotifyUp) {
                    Label("Send Spotify Up", systemImage: "pianokeys")
                }
            .padding(10)
            Button(action: spotifyDown) {
                    Label("Send Spotify Down", systemImage: "pianokeys")
                }
            .padding(1)
            Button(action: appleMusicUp) {
                    Label("Send AM Up", systemImage: "pianokeys")
                }
            .padding(10)
            Button(action: appleMusicDown) {
                    Label("Send AM Down", systemImage: "pianokeys")
                }
            .padding(1)
            Label("\(up)", systemImage: "pianokeys")
        }
        .toolbar {
            
            Button(action: testMIDI) {
                Label("Start MIDI Loop", systemImage: "play")
            }
            Button(action: learnUp) {
                Label("Attempt to learn up", systemImage: "arrow.up")
            }
            
        }
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
