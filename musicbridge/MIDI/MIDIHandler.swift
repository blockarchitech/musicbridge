//
// MIDIHandler.swift
// Created by blockarchitech on 10/23/22
//

import Foundation
import MIDIKitIO

// Variables
var learning = 0
var up = ""
var down = ""

// MIDI Reciever; For init see "musicbridgeApp.swift".
func received(midiEvent: MIDIEvent) {
    switch learning {
    case 1:
        switch midiEvent {
        case .noteOn(let payload):
            print("Up Note: \(payload.note) \(payload.velocity.midi1Value)")
            up = "\(payload.note) \(payload.velocity.midi1Value)"
            learning = 0
            
        case .noteOff(let payload):
            print("Up Note: \(payload.note) \(payload.velocity.midi1Value)")
            up = "\(payload.note) \(payload.velocity.midi1Value)"
            learning = 0
            
        default: print("h1")
        }
    case 2:
        switch midiEvent {
        case .noteOn(let payload):
            print("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            down = "\(payload.note) \(payload.velocity.midi1Value)"
            learning = 0
        case .noteOff(let payload):
            print("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            down = "\(payload.note) \(payload.velocity.midi1Value)"
            learning = 0
        default: print("h2")
        }
    case 0:
        switch midiEvent {
        case .noteOn(let payload):
            print("Note On:", payload.note, payload.velocity, payload.channel)
            if ("\(payload.note) \(payload.velocity.midi1Value)" == up) {
                musicUp()
            } else if ("\(payload.note) \(payload.velocity.midi1Value)" == down) {
                musicDown()
            }
        case .noteOff(let payload):
            print("Note Off:", payload.note, payload.velocity, payload.channel)
            if ("\(payload.note) \(payload.velocity.midi1Value)" == up) {
                musicUp()
            } else if ("\(payload.note) \(payload.velocity.midi1Value)" == down) {
                musicDown()
            }
        case .cc(let payload):
            print("CC:", payload.controller, payload.value, payload.channel)
        case .programChange(let payload):
            print("Program Change:", payload.program, payload.channel)
        default:
            print("h3")
        }
    default:
        print("h4")
    }
}
