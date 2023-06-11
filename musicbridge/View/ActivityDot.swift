//
//  ActivityDot.swift
//  musicbridge
//
//  Created by blockarchitech on 6/10/23.
//

import SwiftUI

struct ActivityDot: View {
    var color: Color
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Circle()
                .fill(color.opacity(0.5))
                .frame(width: 20, height: 20)
        }
    }
}

