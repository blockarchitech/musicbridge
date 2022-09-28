//
//  learndown.swift
//  musicbridge
//
//  Created by blockarchitech on 9/9/22.
//

import Foundation
import CoreMIDI
import Cocoa
public var down = ""

func learndown_getDisplayName(_ obj: MIDIObjectRef) -> String
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

func learndown_MIDIReadProc(pktList: UnsafePointer<MIDIPacketList>,
                    readProcRefCon: UnsafeMutableRawPointer?, srcConnRefCon: UnsafeMutableRawPointer?) -> Void
{
    let packetList:MIDIPacketList = pktList.pointee
    let srcRef:MIDIEndpointRef = srcConnRefCon!.load(as: MIDIEndpointRef.self)

    print("MIDI Received From Source: \(learndown_getDisplayName(srcRef))")
    
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
        
        print("dumped data: \(dumpStr)")
        down = dumpStr
        
        packet = MIDIPacketNext(&packet).pointee
    }
}



func learnDown() {
    var midiClient: MIDIClientRef = 0
    var inPort:MIDIPortRef = 0
    var src:MIDIEndpointRef = MIDIGetSource(0)
    MIDIClientCreate("DOWNLearnClient" as CFString, nil, nil, &midiClient)
    MIDIInputPortCreate(midiClient, "DOWNLearnPort" as CFString, learndown_MIDIReadProc, nil, &inPort)
    MIDIPortConnectSource(inPort, src, &src)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        print("DISPATCH DELAY SET; DISPOSING CLIENT AND ENDPOINT")
        MIDIClientDispose(midiClient)
//        MIDIEndpointDispose(src)
        return;
    }
}

