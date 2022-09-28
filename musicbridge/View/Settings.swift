//
//  Settings.swift
//  musicbridge
//
//  Created by blockarchitech on 8/2/22.
//

import SwiftUI

struct GeneralSettingsView: View {
    enum Players: String, CaseIterable, Identifiable {
        case spotify, am
        var id: Self { self }
    }

    @State private var selectedFlavor: Players = .spotify
    @State var speed = 5.0
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
            
            List {
                Picker("Player", selection: $selectedFlavor) {
                    Text("Spotify").tag(Players.spotify)
                    Text("Apple Music").tag(Players.am)
                }
                .onChange(of: selectedFlavor) { tag in
                    print("tag: \(tag)")
                    setPlayerTag(settag: tag)
                }
            }
//                Text("Current player: \(Player)")
        }
    }
    func setPlayer() { }

}

struct AdvancedSettingsView: View {
    var body: some View {
        VStack {
            Text("MIDI Up Message: \(up)")
            Text("MIDI Down Message: \(down)")
            Text("TODO: Fix this")
//            Button("Learn MIDI Up") {
//                learnUp()
//            }
//            Button("Learn MIDI Down") {
//                learnDown()
//            }
            Divider()
            Text("Due to limitations of SwiftUI, ")
                .font(Font.footnote)
                .fixedSize(horizontal: true, vertical: false)
            Text("Please close and re-open the settings ")
                .font(Font.footnote)
                .fixedSize(horizontal: true, vertical: false)
            Text("window after you have learned your command.")
                .font(Font.footnote)
                .fixedSize(horizontal: true, vertical: false)
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
