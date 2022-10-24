//
//  musicbridgeApp.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import SwiftUI
import Foundation
import MIDIKit

let width = CGFloat(350)
let height = CGFloat(250)
var enginestatus = ""
@main
struct musicbridgeApp: App {
    let midiManager = MIDIManager(
        clientName: "musicbridge-client",
        model: "musicbridgeclient",
        manufacturer: "blockarchitech"
    )
    
    let virtualInputName = "Virtual musicbridge Input"
    
    init() {
        do {
            // prevent thread 1 from going bezerk
            if (up == nil) {
                UserDefaults.standard.set("Not Set", forKey: "up")
            }
            if (down == nil) {
                UserDefaults.standard.set("Not Set", forKey: "down")
            }
            if (fadetime == nil) {
                UserDefaults.standard.set(3.0, forKey: "down")
            }

            print("Starting MIDI services.")
            enginestatus = "running"
            try midiManager.start()
            
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
            enginestatus = "stopped"
        }
    
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: virtualInputName,
                tag: virtualInputName,
                uniqueID: .userDefaultsManaged(key: virtualInputName),
                receiver: .events { events in
                    DispatchQueue.main.async {
                        events.forEach { received(midiEvent: $0) }
                    }
                }
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView().frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height, alignment: .center)
        }
        Settings {
            SettingsView()
        }
    }
}
