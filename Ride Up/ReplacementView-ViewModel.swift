//
//  ReplacementView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 04/10/2023.
//

import Foundation
import SwiftUI

extension ReplacementView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car: Car = Car()
        
        // place to replace
        @Published var replacingPart: String = ""
        let replacablePart: [String] = [
            "Oil", "Oil filter", "Air filter", "Fuel filter", "Cabin Air Filter", "Spark Plugs",
            "Brek Pads", "Brake Rotors", "Timing Belt", "Radiator", "Tires", "Battery",
            "Manual Transmission Fluid"
        ]
        
        //Optional section
        @Published var milageNow: Double? = nil
        
        @Published var changePrice: Double? = nil
        
        
        // must be section
        //
        @Published var replaceType: String = "Time"
        let replaceTypes: [String] = ["Time", "Milage", "Time or Milage"]
        // recomended value of cahnge
        
        
        // inteval of milage
        @Published var milageInterval: Double? = nil
        
        @Published var timeInterval: Double? = nil
        @Published var timeUnit: String = "months"
        let timeUnits: [String] = ["Days", "months", "years"]
        @Published var timeUnitDialog = false
        
        func timeUnitChose(unit: Int)  {
            timeUnit = timeUnits[unit]
        }
        
        func extractCar(cars: Cars) {
            if let chosenCar = cars.cars.first(where: { $0.isChosen }) {
                car = chosenCar
                milageNow = car.millage
            } else { car = Car() }
        }
    }
}
