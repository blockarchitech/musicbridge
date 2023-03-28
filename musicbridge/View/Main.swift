//
//  Main.swift
//  musicbridge
//
//  Created by blockarchitech on 3/27/23.
//

import SwiftUI

struct Main: View {
    var body: some View {
        VStack {
            Image(systemName: "music.note")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("musicbridge")
                .font(Font.title)
                .bold()
        }
        VStack {
            Text("Active. Engine is \(enginestatus).")
                .bold()
                .font(Font.subheadline)
            Text("Ensure settings are correct. CMD+, to set settings.")
                .font(Font.caption)
        }
        .toolbar {
            HStack {
                Button(action: musicUp) {
                    Label("UP", systemImage: "arrow.up")
                }
                Button(action: musicDown) {
                    Label("DOWN", systemImage: "arrow.down")
                }
            }
        }
    }
}
