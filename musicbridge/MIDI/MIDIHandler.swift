//
//  MIDIHandler.swift
//  musicbridge
//
//  Created by blockarchitech on 8/2/22.
//
import Foundation
import MIDIKitIO

public class MIDIModule {
    private let midiManager = MIDIManager(
        clientName: "musicbridgeclient",
        model: "musicbridge",
        manufacturer: "blockarchitech")
    
    let inputTag = "musicbridge_listener"
    
    public init() {
        do {
            try midiManager.start()
            
            try midiManager.addInput(
                name: "musicbridge listener",
                tag: inputTag,
                uniqueID: .userDefaultsManaged(key: inputTag),
                receiver: .events { [weak self] events in
                    // Note: this handler will be called on a background thread
                    // so call the next line on main if it may result in UI updates
                    DispatchQueue.main.async {
                        events.forEach { self?.received(midiEvent: $0) }
                    }
                }
            )
        } catch {
            print("MIDI Setup Error:", error)
        }
    }
    
    private func received(midiEvent: MIDIEvent) {
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
    }
}
