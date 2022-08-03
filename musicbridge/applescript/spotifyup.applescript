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
