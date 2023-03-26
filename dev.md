# Development Information

Mostly for me to track repetitive stuff I do

## Calculating Fadetimes 

Stupid simple. All you do is $f={x \over 100}$ Where $f$ is your fadetime and $x$ is your simple value (in seconds because I can't be bothered to use ms).

## Basic Spotify AppleScript keys

These aren't well documented, so here's some i've found by mindlessly watching activity monitor and `osascript`.

**Note: Always run these keys in a**
```applescript
tell application "Spotify"
  <something>
end tell
```
**Or nothing will work properly**

Use `sound volume` to explain volume cues. Good way of doing this:
```applescript
set vol to the sound volume
```

Basic Music Fade:
```applescript
repeat with i from vol to 0 by -1
    set the sound volume to i
    delay 0.01
end repeat
```

Pause:

Self-explanatory.
```applescript
tell application "Spotify"
  pause
end tell
```

