//
//  MIDIHandler.swift
//  musicbridge
//
//  Created by blockarchitech on 8/2/22.
//

import Foundation
import WebMIDIKit

import CoreMIDI
let midi: MIDIAccess = MIDIAccess(name: "a")
let inputPort: MIDIInput? = midi.inputs.prompt()
public var midiUP = ""
public var midiDOWN = ""
public var inputs = midi.inputs.first

func midiLoop() {
    print("loop started")
    
    inputPort?.onMIDIMessage = { (list: UnsafePointer<MIDIPacketList>) in
        var packet = list.pointee.packet
        let packetByteString = "\(packet.bytes)"
        if (packetByteString == midiUP) {
            spotifyUp()
        } else if (packetByteString == midiDOWN) {
            spotifyDown()
        } else {
            print("unknown packet recieved: \(packetByteString)")
        }
    }
}

// TODO: Find a good way to learn MIDI (or stop the MIDI loop without restarting the app.
func learnMIDIUP() {
    inputPort?.onMIDIMessage = { (list: UnsafePointer<MIDIPacketList>) in
        let packet = list.pointee.packet
        let packetByteString = "\(packet.bytes)"
        midiUP = packetByteString
        print("learned MIDI UP: \(packetByteString)")
        return;
    }
}

func learnMIDIDOWN() {
    var midicount = 0
    guard midicount == 1 else {
        inputPort?.onMIDIMessage = { (list: UnsafePointer<MIDIPacketList>) in
            
            let packet = list.pointee.packet
            let packetByteString = "\(packet.bytes)"
            midiDOWN = packetByteString
            print("learned MIDI DOWN: \(packetByteString)")
            midicount = 1
            
        }
        return;
    }
    
        
}

func checkCommands() {
    if (midiUP == "") {
        print("MIDI UP Command not learned.")
    }
    if (midiDOWN == "") {
        print("MIDI DOWN Command not learned.")
    }
}
