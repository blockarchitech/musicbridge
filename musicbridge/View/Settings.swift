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
        Text("up: \(up)")
            .padding(20)
            .frame(width: 350, height: 100)
    }
}

struct AdvancedSettingsView: View {

    var body: some View {
        VStack {

            Text("MIDI Up: \(up)")
            Text("MIDI Down: \(down)")
            Button {
                learnUp()
            } label: {
                Label("Learn up", systemImage: "pianokeys")
            }
            Button {
                learnDown()
            } label: {
                Label("Learn down", systemImage: "pianokeys")
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
                    Label("MIDI", systemImage: "pianokeys")
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
