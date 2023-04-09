//
// MIDIHandler.swift
// Created by blockarchitech on 10/23/22
//

import Foundation
import MIDIKitIO
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

func handleohno() {
    logger.error("oh no happened")
    learning = 0
}

func received(midiEvent: MIDIEvent) {
    switch learning {
    case 1:
        switch midiEvent {
        case .noteOn(let payload):
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "up")
            UserDefaults.standard.set(0, forKey: "learning")
            
        case .noteOff(let payload):
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "up")
            UserDefaults.standard.set(0, forKey: "learning")
            
        default: logger.info("No Learning trigger for note type.")
        }
    case 2:
        switch midiEvent {
        case .noteOn(let payload):
            logger.debug("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "down")
            UserDefaults.standard.set(0, forKey: "learning")
        case .noteOff(let payload):
            logger.debug("Down Note: \(payload.note) \(payload.velocity.midi1Value)")
            UserDefaults.standard.set("\(payload.note) \(payload.velocity.midi1Value)", forKey: "down")
            UserDefaults.standard.set(0, forKey: "learning")
        default: logger.info("No Learning trigger for note type.")
        }
    case 0:
        switch midiEvent {
        case .noteOn(let payload):
            logger.debug("Note On: \(payload.note)")
            if ("\(payload.note) \(payload.velocity.midi1Value)" == up) {
                musicUp()
            } else if ("\(payload.note) \(payload.velocity.midi1Value)" == down) {
                musicDown()
            }
        case .noteOff(let payload):
            logger.debug("Note Off: \(payload.note)")
            if ("\(payload.note) \(payload.velocity.midi1Value)" == up) {
                musicUp()
            } else if ("\(payload.note) \(payload.velocity.midi1Value)" == down) {
                musicDown()
            }
        case .cc(let payload):
            logger.debug("CC: \(payload.controller) \(payload.channel)")
        case .programChange(let payload):
            logger.debug("Program Change: \(payload.program), \(payload.channel)")
        default:
            logger.fault("Invalid MIDI Note!")
        }
    default:
        logger.fault("oh no happened")
        handleohno()
    }
}
