//
//  ContentView.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
// a a

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
        }
        Divider()
        VStack {
            HStack {
                Text("Development Controls")
                    .bold()
                    .font(.system(size:15))
                VStack {
                    Button(action: spotifyUp) {
                        Label("Send Spotify Up", systemImage: "pianokeys")
                    }
                    .padding(10)
                    Button(action: spotifyDown) {
                        Label("Send Spotify Down", systemImage: "pianokeys")
                    }
                    .padding(1)
                }
                VStack {
                    Button(action: appleMusicUp) {
                        Label("Send AM Up", systemImage: "pianokeys")
                    }
                    .padding(10)
                    Button(action: appleMusicDown) {
                        Label("Send AM Down", systemImage: "pianokeys")
                    }
                    .padding(1)
                }
            }
            Divider()
            HStack {
                Text("MIDI Settings")
                    .bold()
                    .font(.system(size:15))

                Text("Placeholder 100x75")
                    .frame(width: 100, height: 75)
            }
            Divider()
            HStack {
                Text("General Settings")
                    .bold()
                    .font(.system(size:15))

                Text("Placeholder 100x75")
                    .frame(width: 100, height: 75)
            }
            Divider()
        }
        
        
        
        .toolbar {
            HStack {
                
                
                
                Button(action: spotifyUp) {
                    Label("Spotify UP", systemImage: "arrow.up")
                }
                Button(action: spotifyDown) {
                    Label("Spotify DOWN", systemImage: "arrow.down")
                }
                
                Divider()
                
                Button(action: testMIDI) {
                    Label("Start MIDI Loop", systemImage: "play")
                }
                

                
                
            }
            
            
        }
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
