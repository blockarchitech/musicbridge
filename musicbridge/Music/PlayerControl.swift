//
//  PlayerControl.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import Foundation
public var vlu: Double = 0
var fadetime:Double {
    get {
        return UserDefaults.standard.double(forKey:"fadetime")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "fadetime")
   }
 }

// no idea if i'm just stupid or if this is actually needed
func storeSliderValue(sliderval: Double) {
    vlu = sliderval
    UserDefaults.standard.set(sliderval, forKey: "fadetime")
}

func spotifyUp() {
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["""
    -e
    tell application "Spotify"
        if player state is paused then
            set the sound volume to 0
        end if
    end tell
    tell application "Spotify"
        if player state is paused then
            play
        end if
        set volumespotify to the sound volume
        repeat
            repeat with i from volumespotify to 100 by 1
                set the sound volume to i
                delay \(fadetime / 100)
            end repeat
            exit repeat
        end repeat
    end tell
    """]
     
    task.launch()
    
}


func spotifyDown() {
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["""
    -e
    tell application "Spotify"
        if player state is not paused then
            set volumespotify to the sound volume
        end if
    end tell
    tell application "Spotify"
        if player state is not paused then
            repeat
                repeat with i from volumespotify to 0 by -1
                    set the sound volume to i
                    delay \(fadetime / 100)
                end repeat
                pause
                exit repeat
            end repeat
        end if
    end tell
    """]
    
    task.launch()
}

func appleMusicUp() {
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["""
    -e
    tell application "Music"
        if player state is paused then
            set snd to the sound volume
            set snd to 0
            play
            repeat
                repeat with i from snd to 100 by 1
                    set the sound volume to i
                    delay \(fadetime / 100)
                end repeat
                exit repeat
            end repeat
        end if
    end tell
    """]
    
    task.launch()
}

func appleMusicDown() {
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["""
    -e
    tell application "Music"
        if player state is not paused then
            set snd to the sound volume
            repeat
                repeat with i from snd to 0 by -1
                    set the sound volume to i
                    delay \(fadetime / 100)
                end repeat
                pause
                exit repeat
            end repeat
        end if
    end tell
    """]
    
    task.launch()
}
