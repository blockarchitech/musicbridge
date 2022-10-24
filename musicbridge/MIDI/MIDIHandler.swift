//
// MIDIHandler.swift
// Created by blockarchitech on 10/23/22
//

import Foundation
import MIDIKitIO

// Variables
//var learning = 0
//var up = ""
//var down = ""

var up:String! {
    get {
        return UserDefaults.standard.string(forKey:"up")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "up")
   }
 }

var down:String! {
    get {
        return UserDefaults.standard.string(forKey:"down")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "down")
   }
 }

var learning:Int {
    get {
        return UserDefaults.standard.integer(forKey:"learning")
    }
    set {
     UserDefaults.standard.set(newValue, forKey: "learning")
   }
 }
// MIDI Reciever; For init see "musicbridgeApp.swift".
func received(midiEvent: MIDIEvent) {
    switch learning {
    case 1:
        switch midiEvent {
        case .noteOn(let payload):
            print("Up Note: \(payload.note) \(payload.velocity.midi1Value)")
//            up = "\(payload.note) \(payload.velocity.midi1Value)"
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "up")
            UserDefaults.standard.set(0, forKey: "learning")
            
        case .noteOff(let payload):
            print("Up Note: \(payload.note) \(payload.velocity.midi1Value)")
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "up")
            UserDefaults.standard.set(0, forKey: "learning")
            
        default: print("h1")
        }
    case 2:
        switch midiEvent {
        case .noteOn(let payload):
            print("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "down")
            UserDefaults.standard.set(0, forKey: "learning")
        case .noteOff(let payload):
            print("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "down")
            UserDefaults.standard.set(0, forKey: "learning")
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
