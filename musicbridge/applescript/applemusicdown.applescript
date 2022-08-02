tell application "Music"
    if player state is not paused then
        set snd to the sound volume
        repeat
            repeat with i from snd to 0 by -1
                set the sound volume to i
                delay 0.1
            end repeat
            pause
            exit repeat
        end repeat
    end if
end tell
