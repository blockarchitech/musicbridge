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
