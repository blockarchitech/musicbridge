//
//  DevMenu.swift
//  musicbridge
//
//  Created by blockarchitech on 6/11/23.
//

import SwiftUI

struct DevMenu: View {
    var body: some View {
        VStack {
            Text("Dev Menu")
                .bold()
                .font(Font.title)
            Button {
                UserDefaults.standard.set(0, forKey: "fadetime")
                UserDefaults.standard.set("Not Set", forKey: "up")
                UserDefaults.standard.set("Not Set", forKey: "down")
            } label: {
                Text("Clear UserDefaults (restart app after this)")
            }
            Button {
                UserDefaults.standard.set(0, forKey: "fadetime")
            } label: {
                Text("Clear fadetime")
            }
            Button {
                UserDefaults.standard.set("Not Set", forKey: "up")
            } label: {
                Text("Clear up")
            }
            Button {
                UserDefaults.standard.set("Not Set", forKey: "down")
            } label: {
                Text("Clear down")
            }
            

            
        }
        .frame(minWidth: 150, maxWidth: 150, minHeight: 200, maxHeight: 200)
    }
}

// button to open dev menu
struct DevMenuButton: View {
    @State var showDevMenu = false
    var body: some View {
        VStack {
            Text("musicbridge")
                .bold()
                .font(Font.title)
                .onTapGesture {
                    showDevMenu.toggle()
                }
        }
        .sheet(isPresented: $showDevMenu) {
            DevMenu()
        }
    }
}


