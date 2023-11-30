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
        
        @Published var fuelEconomyUnit: String = "l/100km"
        let fuelEconomyUnits = ["l/100km","mpg (USA)","mpg (UK)","km/l","kWh/100mi","gal/100mi","kg/100km"]
        
        @Published var fuelType = "Petrol"
        let fuelTypes = ["Petrol", "Diesel", "Electric", "LPG", "CNG","Ethanol"]
        
        @Published var secondTank = "none"
        
    }
}
