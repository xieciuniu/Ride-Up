//
//  AddCarView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 30/11/2023.
//

import Foundation

extension AddCarView {
    @MainActor class ViewModel: ObservableObject {
        @Published var distanceUnit: String = "Kilometres"
        let distanceUnits = ["Kilometres", "Miles"]
        
        @Published var fuelUnit: String = "Litres"
        let fuelUnits = ["Litres", "Gallons (USA)", "Gallons (UK)", "kWh", "kg", "m³"]
    }
}
