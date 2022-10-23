//
// MIDIHandler.swift
// Created by blockarchitech on 10/23/22
//

import Foundation
import MIDIKitIO

// Variables
public var learning = "up"
public var up = ""
public var down = ""

// MIDI Reciever; For init see "musicbridgeApp.swift".
func received(midiEvent: MIDIEvent) {
    switch learning {
    case "up":
        switch midiEvent {
        case .noteOn(let payload):
            print("Up Note: \(payload.note) \(payload.velocity.midi1Value)")
            up = "\(payload.note) \(payload.velocity.midi1Value)"
            break
        case .noteOff(let payload):
            print("Up Note: \(payload.note) \(payload.velocity.midi1Value)")
            up = "\(payload.note) \(payload.velocity.midi1Value)"
            break
        default: break
        }
    case "down":
        switch midiEvent {
        case .noteOn(let payload):
            print("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            down = "\(payload.note) \(payload.velocity.midi1Value)"
            break
        case .noteOff(let payload):
            print("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            down = "\(payload.note) \(payload.velocity.midi1Value)"
            break
        default: break
        }
    case "no":
        switch midiEvent {
        case .noteOn(let payload):
            print("Note On:", payload.note, payload.velocity, payload.channel)
        case .noteOff(let payload):
            print("Note Off:", payload.note, payload.velocity, payload.channel)
        case .cc(let payload):
            print("CC:", payload.controller, payload.value, payload.channel)
        case .programChange(let payload):
            print("Program Change:", payload.program, payload.channel)
        default:
            break
        }
    default:
        break
    }
}
