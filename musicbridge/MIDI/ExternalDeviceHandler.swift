//
//  ExternalDeviceHandler.swift
//  musicbridge
//
//  Created by blockarchitech on 4/23/23.
//

import Foundation
import MIDIKit

class ExternalDeviceHelper: ObservableObject {
    public weak var midiManager: MIDIManager?
    
    @Published
    public private(set) var receivedEvents: [MIDIEvent] = []
    
    public init() { }
    
    public func extReciever(midiEvent: MIDIEvent) {
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
    
    /// Run once after setting the local ``midiManager`` property.
    public func initialSetup() {
        guard let midiManager = midiManager else {
            print("MIDIManager is missing.")
            return
        }
    
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        do {
            try midiManager.addInputConnection(
                toOutputs: [],
                tag: ConnectionTags.midiIn,
                receiver: .events { [weak self] events in
                    DispatchQueue.main.async {
                        events.forEach { self!.extReciever(midiEvent: $0) }
                    }
                }
            )

        } catch {
            print("Error creating MIDI connections:", error.localizedDescription)
        }
    }
    
    // MARK: - MIDI In
    
    public var midiInputConnection: MIDIInputConnection? {
        midiManager?.managedInputConnections[ConnectionTags.midiIn]
    }
    
    public func midiInUpdateConnection(selectedUniqueID: MIDIIdentifier) {
        guard let midiInputConnection = midiInputConnection else { return }
    
        if selectedUniqueID == .invalidMIDIIdentifier {
            midiInputConnection.removeAllOutputs()
        } else {
            if midiInputConnection.outputsCriteria != [.uniqueID(selectedUniqueID)] {
                midiInputConnection.removeAllOutputs()
                midiInputConnection.add(outputs: [.uniqueID(selectedUniqueID)])
            }
        }
    }
    // MARK: - Helpers
    
    public func isInputPresentInSystem(uniqueID: MIDIIdentifier) -> Bool {
        midiManager?.endpoints.inputs.contains(whereUniqueID: uniqueID) ?? false
    }
    public func isOutputPresentInSystem(uniqueID: MIDIIdentifier) -> Bool {
        midiManager?.endpoints.outputs.contains(whereUniqueID: uniqueID) ?? false
    }
}
