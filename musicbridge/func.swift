//
//  func.swift
//  musicbridge
//
//  Created by blockarchitech on 8/1/22.
//

import Foundation

// QUICK NOTE TO CONTRIBUTORS:
// Please edit the .applescript files if you are editing any of this applescript aswell.

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
                delay 0.01
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
                    delay 0.01
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
                    delay 0.01
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
                    delay 0.01
                end repeat
                pause
                exit repeat
            end repeat
        end if
    end tell
    """]
    
    task.launch()
}

func openSettingsView() {
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["""
    -e
    tell application "System Events" to keystroke "," using {command down}
    """]
    
    task.launch()
}
