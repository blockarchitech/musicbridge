//
//  ExternalDeviceInputSelectionView.swift
//  musicbridge
//
//  Created by blockarchitech on 4/23/23.
//

import SwiftUI
import MIDIKitIO

struct ExternalDeviceInputSelectionView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: ExternalDeviceHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    
    var body: some View {
        Picker("Device", selection: $midiInSelectedID) {
            Text("None")
                .tag(0 as MIDIIdentifier)
    
            if midiInSelectedID != .invalidMIDIIdentifier,
               !midiHelper.isOutputPresentInSystem(uniqueID: midiInSelectedID)
            {
                Text("⚠️ " + midiInSelectedDisplayName)
                    .tag(midiInSelectedID)
                    .foregroundColor(.secondary)
            }
    
            ForEach(midiManager.endpoints.outputs) {
                Text($0.displayName)
                    .tag($0.uniqueID)
            }
        }
    }
}
