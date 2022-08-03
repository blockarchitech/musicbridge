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


func midiTest() {
    inputPort?.onMIDIMessage = { (list: UnsafePointer<MIDIPacketList>) in
        for packet in list {
            print("received \(packet)")
        }
		
    }
	// clear the buffer
	
}
