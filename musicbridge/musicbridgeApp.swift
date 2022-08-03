//
//  musicbridgeApp.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import SwiftUI
import Foundation

let width = CGFloat(500)
let height = CGFloat(300)

@main
struct musicbridgeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height, alignment: .center)
        }
        Settings {
                    SettingsView()
                }
    }
    
}
