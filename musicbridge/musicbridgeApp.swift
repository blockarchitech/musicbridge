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
import FirebaseCore




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
        FirebaseApp.configure()
        logger.debug("Finished App Delegate. Configured.")
    }
}

var enginestatus = ""
let logger = Logger()

@main
struct musicbridgeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let midiManager = MIDIManager(
        clientName: "musicbridge-client",
        model: "musicbridgeclient",
        manufacturer: "blockarchitech"
    )
    
    var externalDeviceHelper = ExternalDeviceHelper()
    
    @State var midiInSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    @State var midiInSelectedDisplayName: String = "None"
    
    let virtualInputName = "Virtual musicbridge Input"
    
    init() {
        
        do {
            FirebaseApp.configure()
            
            externalDeviceHelper.midiManager = midiManager
            externalDeviceHelper.initialSetup()
        
            // restore saved MIDI endpoint selections and connections
            midiRestorePersistentState()
            externalDeviceHelper.midiInUpdateConnection(selectedUniqueID: midiInSelectedID)
            
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
            logger.error("Error creating virtual MIDI input: \(error.localizedDescription)")
        }
    }
    let width = 600
    let height = 500
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
            .environmentObject(externalDeviceHelper)
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

extension musicbridgeApp {
    /// This should only be run once at app startup.
    private mutating func midiRestorePersistentState() {
        print("Restoring saved MIDI connections.")
    
        let inName = UserDefaults.standard.string(forKey: UserDefaultsKeys.midiInDisplayName) ?? ""
        _midiInSelectedDisplayName = State(wrappedValue: inName)
    
        let inID = Int32(
            exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiInID)
        ) ?? .invalidMIDIIdentifier
        _midiInSelectedID = State(wrappedValue: inID)
    
    }
    
    public func midiSavePersistentState() {
        UserDefaults.standard.set(
            midiInSelectedID,
            forKey: UserDefaultsKeys.midiInID
        )
        UserDefaults.standard.set(
            midiInSelectedDisplayName,
            forKey: UserDefaultsKeys.midiInDisplayName
        )
    }
}
