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
            Text("Stupid MIDI to AppleScript converter")
            Button(action: spotifyUp) {
                    Label("Send Spotify Up", systemImage: "pianokeys")
                }
            .padding(10)
            Button(action: spotifyDown) {
                    Label("Send Spotify Down", systemImage: "pianokeys")
                }
            .padding(1)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
