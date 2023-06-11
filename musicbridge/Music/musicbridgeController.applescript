-- musicbridge controller
-- (c) znci 2023 - hello@znci.dev
-- --
-- For testing only.
script musicbridgeController
    property parent : class "NSObject"
    
    -- running checks
    to _spotifyRunning()
        return running of application id "com.spotify.client"
    end _spotifyRunning
    to _appleMusicRunning()
        return running of application id "com.apple.Music"
    end _appleMusicRunning
    
    -- spotify controller
    to spotifyUp(fadetime)
        tell application "Spotify"
            set vlm to 100
            repeat with vlm from 100 to 0 by -1
                set the sound volume to vlm
                delay fadetime / 100
            end repeat
        end tell
    end spotifyUp
    to spotifyDown(fadetime)
        tell application "Spotify"
            play
            set vlm to 0
            repeat with vlm from 0 to 100 by 1
                set the sound volume to vlm
                delay fadetime / 100
            end repeat
        end tell
    end spotifyDown
    
    -- applemusic controller
    to appleMusicUp(fadetime)
        tell application "Music"
            play
            repeat with vlm from 0 to 100 by 1
                set the sound volume to vlm
                delay fadetime / 100
            end repeat
        end tell
    end appleMusicUp
    to appleMusicDown(fadetime)
        tell application "Music"
            play
            repeat with vlm from 100 to 0 by -1
                set the sound volume to vlm
                delay fadetime / 100
            end repeat
        end tell
    end appleMusicDown
    
end script




