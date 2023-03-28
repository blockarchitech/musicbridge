//
//  WindowCommands.swift
//  musicbridge
//
//  Created by blockarchitech 3/27/23.
//

import Foundation
import SwiftUI


struct AppCommands: Commands {
    
    func openLogger() {
        print("Action")
    }

    
    @CommandsBuilder var body: some Commands {
        CommandMenu("Logger") {
            Button(action: {
                openLogger()
            }) {
                Text("Open Logger")
            }
            .keyboardShortcut("l", modifiers: .command)
            .disabled(true)
        }
    }
}
