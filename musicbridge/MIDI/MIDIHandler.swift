//
//  MIDIHandler.swift
//  musicbridge
//
//  Created by blockarchitech on 8/2/22.
//

import Cocoa
import CoreMIDI

// this is actually very useful and might use it in *something*
// right now this file is basically only for testing
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

func test_MIDIReadProc(pktList: UnsafePointer<MIDIPacketList>,
                    readProcRefCon: UnsafeMutableRawPointer?, srcConnRefCon: UnsafeMutableRawPointer?) -> Void
{
    let packetList:MIDIPacketList = pktList.pointee
    let srcRef:MIDIEndpointRef = srcConnRefCon!.load(as: MIDIEndpointRef.self)

    print("MIDI Received From Source: \(getDisplayName(srcRef))")
    
    var packet:MIDIPacket = packetList.packet
    for _ in 1...packetList.numPackets
    {
        let bytes = Mirror(reflecting: packet.data).children
        var dumpStr = ""
        
        // bytes mirror contains all the zero values in the ridiulous packet data tuple
        // so use the packet length to iterate.
        var i = packet.length
        for (_, attr) in bytes.enumerated()
        {
            dumpStr += String(format:"$%02X ", attr.value as! UInt8)
            i -= 1
            if (i <= 0)
            {
                break
            }
        }
        
        print(dumpStr)
        if (dumpStr == "$80 $00 $00 ") {
            musicUp()
        } else if (dumpStr == "$80 $00 $40 ") {
            musicDown()
        }
        packet = MIDIPacketNext(&packet).pointee
    }
}

func testMIDI() {
    // quick demo to assemble MIDI and start the task loop.
    var midiClient: MIDIClientRef = 0
    var inPort:MIDIPortRef = 0
    var src:MIDIEndpointRef = MIDIGetSource(0)

    MIDIClientCreate("MidiTestClient" as CFString, nil, nil, &midiClient)
    MIDIInputPortCreate(midiClient, "MidiTest_InPort" as CFString, test_MIDIReadProc, nil, &inPort)

    MIDIPortConnectSource(inPort, src, &src)
}
