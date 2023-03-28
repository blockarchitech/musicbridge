//
//  ContentView.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
// 

import SwiftUI

let width = CGFloat(350)
let height = CGFloat(250)

struct MainScene: Scene {
    var body: some Scene {
        WindowGroup {
            Main().frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height, alignment: .center)
        } .commands {
            AppCommands()
            
        }
        Settings {
            SettingsView()
        }
    }
}
