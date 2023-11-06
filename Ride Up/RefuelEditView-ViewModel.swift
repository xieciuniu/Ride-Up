//
//  RefuelEditView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 05/11/2023.
//

import Foundation

extension RefuelEditView {
    @MainActor class ViewModel: ObservableObject {
        @Published var fuelVariable: FuelEconomy = FuelEconomy()
        @Published var date: Date = Date.now
        
        func extractVariable(cars: Cars, id: UUID) {
            if let thisCar = cars.cars.first(where: {$0.isChosen == true}) {
                if let thisRefill = thisCar.fuel.first(where: {$0.id == id }) {
                    fuelVariable = thisRefill
                    date = fuelVariable.date ?? Date.now
                    
                    refillType = thisRefill.isFull ? "Full" : "Partly"
                }
            }
        }
        
        func saveVariable(){
            self.fuelVariable.date = date
            self.fuelVariable.isFull = isFull
        }
        
        let waluta: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
        var value: Measurement<UnitVolume> {
            return Measurement(value: self.fuelVariable.tankedFuel ?? 5, unit: UnitVolume.liters)}

        @Published var refillType = "Full"
        let refillOptions: [String] = [ "Full", "Partly" ]
        var isFull: Bool {
            switch self.refillType{
            case "Full":
                return true
            case "Partly":
                return false
            default:
                return true
            }
        }
    }
}
