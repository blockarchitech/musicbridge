//
//  musicbridgeApp.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import SwiftUI
import Foundation
import MIDIKit
extension Bundle {
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}
let build = Bundle.main.buildNumber
let version = build


@objc
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var token: NSKeyValueObservation?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Adjust a menu initially
        if let m = NSApp.mainMenu?.item(withTitle: "Edit") {
            NSApp.mainMenu?.removeItem(m)
        }
        if let m = NSApp.mainMenu?.item(withTitle: "File") {
            NSApp.mainMenu?.removeItem(m)
        }
        if let m = NSApp.mainMenu?.item(withTitle: "View") {
            NSApp.mainMenu?.removeItem(m)
        }
        if let m = NSApp.mainMenu?.item(withTitle: "Help") {
            NSApp.mainMenu?.removeItem(m)
        }
        if let m = NSApp.mainMenu?.item(withTitle: "Window") {
            NSApp.mainMenu?.removeItem(m)
        }
        
        

        // Must refresh after every time SwiftUI re adds
        token = NSApp.observe(\.mainMenu, options: .new) { (app, change) in
            // Refresh your changes
            guard let menu = app.mainMenu?.item(withTitle: "Edit") else { return }

            app.mainMenu?.removeItem(menu)
        }
    }
}

var enginestatus = ""
@main
struct musicbridgeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

            enginestatus = "running"
            try midiManager.start()
        } catch {
            enginestatus = "stopped"
        }
    
        do {
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
        MainScene()
    }
}
