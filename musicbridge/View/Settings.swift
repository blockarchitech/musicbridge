//
//  Settings.swift
//  musicbridge
//
//  Created by blockarchitech on 8/2/22.
//

import SwiftUI
import MIDIKit

struct GeneralSettingsView: View {
    enum Players: String, CaseIterable, Identifiable {
        case spotify, am
        var id: Self { self }
    }
    @State private var selectedFlavor: Players = .spotify
    @State var speed = fadetime
    @State var isEditing = false
    var body: some View {
        VStack {
            Slider(
                value: $speed,
                in: 0...5,
                step: 0.75
            ) {
                Text("Fade Time")
            } minimumValueLabel: {
                Text("0s")
            } maximumValueLabel: {
                Text("5s")
            } onEditingChanged: { editing in
                storeSliderValue(sliderval: speed)
                isEditing = editing
            }
            Text(
                String(format: "%.2f", speed)
            )
                .foregroundColor(isEditing ? .red : .blue)
            
            Divider()
            
            
            Picker("Player", selection: $selectedFlavor) {
                Text("Spotify").tag(Players.spotify)
                Text("Apple Music").tag(Players.am)
            }
            .onChange(of: selectedFlavor) { tag in
                setPlayerTag(settag: tag)
                }
        }
    }
    func setPlayer() { }
}

struct LearnUpView: View {
    @AppStorage("up") var up: String = UserDefaults.standard.string(forKey:"up") ?? ""
    var body: some View {
        VStack {
            Text(up.split(separator: " ").first ?? "")
                .font(.system(size: 25, design: .monospaced))
            HStack {
                Text("Velocity")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.secondary)
                Text(up.split(separator: " ").last ?? "")
                    .font(.system(size: 15, design: .rounded))
                    .bold()
                    .foregroundColor(.secondary)
            }
            
            
            Button("Learn Up") {
                UserDefaults.standard.set(1, forKey: "learning")
            }
            .padding()
        }
    }

}
struct LearnDownView: View {
    @AppStorage("down") var down: String = UserDefaults.standard.string(forKey:"down") ?? ""
    var body: some View {
        VStack {
            Text(down.split(separator: " ").first ?? "")
                .font(.system(size: 25, design: .monospaced))
            HStack {
                Text("Velocity")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.secondary)
                Text(up.split(separator: " ").last ?? "")
                    .font(.system(size: 15, design: .rounded))
                    .bold()
                    .foregroundColor(.secondary)
            }
            
            
            Button("Learn Down") {
                UserDefaults.standard.set(2, forKey: "learning")
            }
            .padding()
        }
    }

}

struct ExternalDeviceSettings: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    var body: some View {
        VStack {
            Text("Select an MIDI device to use with musicbridge")
                .bold()
            Divider()
            HStack {
                MIDIInSelectionView(midiInSelectedID: $midiInSelectedID, midiInSelectedDisplayName: $midiInSelectedDisplayName)
            }
        }
    }
}

struct AdvancedSettingsView: View {
    var body: some View {
        VStack {
            HStack {
                LearnUpView()
                Divider()
                LearnDownView()
                
            }
        }
    }
}
struct InfoView: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "music.note")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                DevMenuButton()
                Text("Version \(version)")
                    .foregroundColor(Color.secondary)
                    .font(Font.subheadline)
            }
            Divider()
            VStack {
                HStack {
                    Text("A")
                    Text("znci")
                        .foregroundColor(Color("zncigreen"))
                        .bold()
                    Text("project.")
                }
                HStack {
                        Link("Source",
                              destination: URL(string: "https://github.com/znci/musicbridge")!)
                    Divider()
                    Link("Issues",
                          destination: URL(string: "https://github.com/znci/musicbridge/issues")!)
                    Divider()
                    Link("Contact",
                          destination: URL(string: "mailto:hello@znci.dev")!)
                }
            }
            
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    private enum Tabs: Hashable {
        case general, advanced, cloud, info, looptimus, extdevset
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            ExternalDeviceSettings(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName
            )
                .tabItem {
                    Label("MIDI Device", systemImage: "pianokeys")
                }
                .tag(Tabs.extdevset)
            AdvancedSettingsView()
                .tabItem {
                    Label("Learning", systemImage: "waveform.path.ecg.rectangle")
                }
                .tag(Tabs.advanced)
            InfoView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }

                .tag(Tabs.info)
            
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

