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

## Might use this later
```swift
import Cocoa
import CoreMIDI
import PlaygroundSupport
func getDisplayName(_ obj: MIDIObjectRef) -> String
{
    var param: Unmanaged<CFString>?
    var name: String = "Error"

    let err: OSStatus = MIDIObjectGetStringProperty(obj, kMIDIPropertyDisplayName, &param)
    if err == OSStatus(noErr)
    {
        name =  param!.takeRetainedValue() as String
    }

    return name
}

func getDestinationNames() -> [String]
{
    var names:[String] = [];

    let count: Int = MIDIGetNumberOfDestinations();
    for i in 0..<count {
        let endpoint:MIDIEndpointRef = MIDIGetDestination(i);

        if (endpoint != 0)
        {
            names.append(getDisplayName(endpoint));
        }
    }
    return names;
}

func getSourceNames() -> [String]
{
    var names:[String] = [];

    let count: Int = MIDIGetNumberOfSources();
    for i in 0..<count {
        let endpoint:MIDIEndpointRef = MIDIGetSource(i);
        if (endpoint != 0)
        {
            names.append(getDisplayName(endpoint));
        }
    }
    return names;
}

func testMIDI() {
    let destNames = getDestinationNames();

    print("Number of MIDI Destinations: \(destNames.count)");
    for destName in destNames
    {
        print("  Destination: \(destName)");
    }

    let sourceNames = getSourceNames();

    print("\nNumber of MIDI Sources: \(sourceNames.count)");
    for sourceName in sourceNames
    {
        print("  Source: \(sourceName)");
    }

}
```

