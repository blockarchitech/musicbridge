//
//  musicbridgeController.swift
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
func storeSliderValue(sliderval: Double) {
    vlu = sliderval
    UserDefaults.standard.set(sliderval, forKey: "fadetime")
}

func convertKeyToAEKeyword(_ key: String) -> AEKeyword {
    let data = key.data(using: .macOSRoman)!
    return data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> AEKeyword in
        return AEKeyword(bitPattern: Int32(ptr.pointee))
    }
}


func parseNSAppleEventDescriptor(_ descriptor: NSAppleEventDescriptor) -> [String: Any] {
    var dict = [String: Any]()
    for key in descriptor.attributeKeys {
        let value = descriptor.attributeDescriptor(forKeyword: convertKeyToAEKeyword(key))?.stringValue
        dict[key] = value
    }
    return dict
}

func returnAllNSDictKeys(_ dict: NSDictionary) -> [String] {
    // add keys and values to array
    var keys = [String]()
    for key in dict.allKeys {
        keys.append(key as! String)
    }
    return keys
}

// return all NSDict key values
func returnAllNSDictValues(_ dict: NSDictionary) -> [Any] {
    // add keys and values to array
    var values = [Any]()
    for value in dict.allValues {
        values.append(value)
    }
    return values
}

struct musicbridgeController {
    func amUp() {
        let script = NSAppleScript(source: """
        tell application "Music"
            play
            repeat with vlm from 0 to 100 by 1
                set the sound volume to vlm
                delay \(fadetime / 100)
            end repeat
        end tell
        """)
        async {
            var err = NSDictionary?(nilLiteral: ())
            script?.compileAndReturnError(&err)
            var _success = script?.executeAndReturnError(&err)
            if (err != nil) {
                guard err == nil else { fatalError("Execution Error!") }
            } else {
                logger.debug("[controller] AM triggered Up")
            }
        }
    }
    func amDown() {
        let script = NSAppleScript(source: """
        tell application "Music"
            play
            repeat with vlm from 100 to 0 by -1
                set the sound volume to vlm
                delay \(fadetime / 100)
            end repeat
        end tell
        """)
        async {
            var err = NSDictionary?(nilLiteral: ())
            script?.compileAndReturnError(&err)
            var _success = script?.executeAndReturnError(&err)
            if (err != nil) {
                guard err == nil else { fatalError("Execution Error!") }
            } else {
                logger.debug("[controller] AM triggered Down")
            }
        }
    }
    func spUp() {
        let script = NSAppleScript(source: """
        tell application "Spotify"
            play
            set vlm to 0
            repeat with vlm from 0 to 100 by 1
                set the sound volume to vlm
                delay \(fadetime / 100)
            end repeat
        end tell
        """)
        async {
            var err = NSDictionary?(nilLiteral: ())
            script?.compileAndReturnError(&err)
            var _success = script?.executeAndReturnError(&err)
            if (err != nil) {
                guard err == nil else { fatalError("Execution Error!") }
            } else {
                logger.debug("[controller] Spotify triggered up")
            }
        }
    }
    func spDown() {
        let script = NSAppleScript(source: """
        tell application "Spotify"
            set vlm to 100
            repeat with vlm from 100 to 0 by -1
                set the sound volume to vlm
                delay \(fadetime / 100)
            end repeat
            pause
        end tell
        """)
        async {
            var err = NSDictionary?(nilLiteral: ())
            script?.compileAndReturnError(&err)
            var _success = script?.executeAndReturnError(&err)
            if (err != nil) {
                guard err == nil else { fatalError("Execution Error!") }
            } else {
                logger.debug("[controller] Spotify triggered down")
            }
        }

    }
}


