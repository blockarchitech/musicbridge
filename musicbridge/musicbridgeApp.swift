//
//  musicbridgeApp.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import SwiftUI
import Foundation
import OSLog
import MIDIKit


extension Bundle {
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}
let build = Bundle.main.buildNumber
let version = build
let Controller = musicbridgeController()

func async(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: block)
}

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
        token = NSApp.observe(\.mainMenu, options: .new) { (app, change) in
            // Refresh your changes
            guard let menu = app.mainMenu?.item(withTitle: "Edit") else { return }

            app.mainMenu?.removeItem(menu)
        }
        logger.debug("Finished App Delegate. Configured.")
    }
}

var enginestatus = ""
var midistatus = "stopped"
let logger = Logger()

@main
struct musicbridgeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let midiManager = MIDIManager(
            clientName: "musicbridge",
            model: "MBController",
            manufacturer: "znci"
        )
        
        let midiHelper = MIDIHelper()
        
        @AppStorage(MIDIHelper.PrefKeys.midiInID)
        var midiInSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
        
        @AppStorage(MIDIHelper.PrefKeys.midiInDisplayName)
        var midiInSelectedDisplayName: String = "None"
        
        @AppStorage(MIDIHelper.PrefKeys.midiOutID)
        var midiOutSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
        
        @AppStorage(MIDIHelper.PrefKeys.midiOutDisplayName)
        var midiOutSelectedDisplayName: String = "None"
        
        init() {
            midiHelper.setup(midiManager: midiManager)
            // restore saved MIDI endpoint selections and connections
            midiHelper.midiInUpdateConnection(selectedUniqueID: midiInSelectedID)
            midiHelper.midiOutUpdateConnection(selectedUniqueID: midiOutSelectedID)
            enginestatus = "running"
        }
    let width = 715
    let height = 600
    var body: some Scene {
        WindowGroup {
            Main()
        } .commands {
            AppCommands()
            
        }
        Settings {
            SettingsView(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName
            )
            .environmentObject(midiManager)
            .environmentObject(midiHelper)
        }
        .onChange(of: midiInSelectedID) { uid in
                   // cache endpoint name persistently so we can show it in the event the endpoint disappears
                   if uid == .invalidMIDIIdentifier {
                       midiInSelectedDisplayName = "None"
                   } else if let found = midiManager.endpoints.outputs.first(whereUniqueID: uid) {
                       midiInSelectedDisplayName = found.displayName
                   }
           
                   midiHelper.midiInUpdateConnection(selectedUniqueID: uid)
               }
               .onChange(of: midiOutSelectedID) { uid in
                   // cache endpoint name persistently so we can show it in the event the endpoint disappears
                   if uid == .invalidMIDIIdentifier {
                       midiOutSelectedDisplayName = "None"
                   } else if let found = midiManager.endpoints.inputs.first(whereUniqueID: uid) {
                       midiOutSelectedDisplayName = found.displayName
                   }
           
                   midiHelper.midiOutUpdateConnection(selectedUniqueID: uid)
               }
    }
}

enum ConnectionTags {
    static let midiIn = "SelectedInputConnection"
}

enum UserDefaultsKeys {
    static let midiInID = "SelectedMIDIInID"
    static let midiInDisplayName = "SelectedMIDIInDisplayName"
}


