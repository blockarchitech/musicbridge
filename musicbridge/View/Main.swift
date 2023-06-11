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
            VStack {
                Text("musicbridge")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    if (enginestatus == "running") {
                        
                        Text("Running")
                            .bold()
                            .foregroundColor(.green)
                        ActivityDot(color: .green)
                    } else {
                        Text("Error")
                            .bold()
                            .foregroundColor(.red)
                        ActivityDot(color: .red)
                    }
                }
                Divider()
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("Ensure settings are correct. Open CMD+, to open settings.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 10)
            
            Spacer()
            
            
            VStack {
                
                Image(systemName: "music.note")
                    .imageScale(.large)
                .foregroundColor(.accentColor)
                Text("Version \(version)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text("© 2023 znci")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 10)
            
        }
        .frame(width: 300, height: 200)
        // toolbar with up/down buttons and a settings button
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    musicUp()
                }) {
                    Image(systemName: "arrow.up")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    musicDown()
                }) {
                    Image(systemName: "arrow.down")
                }
            }
        }
    }
}


