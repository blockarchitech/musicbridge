//
//  Settings.swift
//  musicbridge
//
//  Created by blockarchitech on 8/2/22.
//

import SwiftUI
import Gong
struct GeneralSettingsView: View {
    var body: some View {
        Text("Placeholder 350x100")
            .padding(20)
            .frame(width: 350, height: 100)
    }
}

struct AdvancedSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0
    @State private var delaytime: String = ""

    var body: some View {
        VStack {
            
            Text("MIDI Up: \(midiUP)")
            Text("MIDI Down: \(midiDOWN)")
            Button {
                learnMIDIUP()
            } label: {
                Label("Learn UP", systemImage: "pianokeys")
            }
            Button {
                learnMIDIDOWN()
            } label: {
                Label("Learn DOWN", systemImage: "pianokeys")
            }
        }
    }
}

//struct MIDIListView: View {
//    @AppStorage("chosendevice") private var showPreview = true
//    var body: some View {
//
//    }
//}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            AdvancedSettingsView()
                .tabItem {
                    Label("Advanced", systemImage: "star")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
