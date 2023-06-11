//
//  PlayerSwitcher.swift
//  musicbridge
//
//  Created by blockarchitech on 9/16/22.
//

import Foundation

// Allowed options are "spotify" and "apple-music"
var Player = "spotify"

func setPlayerTag(settag: GeneralSettingsView.Players) {
    Player = "\(settag)"
}
func musicUp() {
    if (Player == "spotify") {
        Controller.spUp()
    } else if (Player == "am") {
        Controller.amUp()
    }
}
func musicDown() {
    if (Player == "spotify") {
        Controller.spDown()
    } else if (Player == "am") {
        Controller.amUp()
    }
}
