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
                delay 0.1
            end repeat
            pause
            exit repeat
        end repeat
    end if
end tell
