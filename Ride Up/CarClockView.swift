//
//  CarClockView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 21/09/2023.
//

import SwiftUI

struct SpeedometerView: View {
    @State private var speed: Double = 0.0

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
            
            Text("I")
        }
    }
}

struct SpeedometerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedometerView()
    }
}
