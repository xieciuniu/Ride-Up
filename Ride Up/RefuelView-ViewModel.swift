//
//  RefuelView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 27/10/2023.
//

import Foundation
import SwiftUI
import UIKit

extension RefuelView {
    @MainActor class ViewModel: ObservableObject {
        // car variable to operate on it
        @Published var car = Car()
        
        // function to extraxt this car from whole document
        func extractCar(cars: Cars) {
            if let thisCar = cars.cars.first(where: {$0.isChosen == true}) {
                car = thisCar
            }
        }
        
        // refil options
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
        
//        func refilType() {
//            switch self.refillType {
//            case "Full":
//                isFull = true
//            case "Partly":
//                isFull = false
//            default:
//                isFull = true
//            }
//        }
        
        
        //tank status
        @Published var tankStatus: Double = 6
        @Published var tankStatusBefore: Double = 1
        let tankStatuses = ["0", "1/8", "2/8", "3/8", "4/8", "5/8", "6/8", "7/8", "1"]
        var tankAfter: Double {
            tankStatus / 8
        }
        var tankBefore: Double {
            tankStatusBefore / 8
        }
        
        
        // fuel variables
        @Published var tankedFuel: Double? = nil
        @Published var fuelPricePerLiter: Double = 3.55
        @Published var fuelPrice: Double = 123.45
        var fuelPerLiterWasChanged: Bool = true
        @Published var amountCounted: Double = 0.0
        
        @Published var toKick = 1
        
        
        func perLiterChanged() {
            if let tanked = tankedFuel {
                if tanked != 0 {
                    amountCounted = round(fuelPricePerLiter * tanked * 100 ) / 100
                }
            }
            fuelPerLiterWasChanged = true
        }
        func overallChanged() {
            if let tanked = tankedFuel {
                if tanked != 0 {
                    amountCounted = round((fuelPrice / tanked) * 100) / 100
                }
            }
            fuelPerLiterWasChanged = false
        }
        func tankedWasChanged() {
            if let tanked = tankedFuel {
                if tanked != 0 {
                    if (fuelPerLiterWasChanged) {
                        amountCounted = round(fuelPricePerLiter * tanked * 100 ) / 100
                    } else {
                        amountCounted = round((fuelPrice / tanked) * 100) / 100
                    }
                }
            }
        }
        
        // Millage
        @Published var mileageOption = "Since last refueling"
        let mileageOptions = ["Overall", "Since last refueling"]
        var isMileageOverall: Bool {
            switch mileageOption {
            case "Overall":
                return true
            case "Since last refueling":
                return false
            default:
                return true
            }
        }
        @Published var mileageAll: Double = 200_000
        @Published var mileageSinceRefueling: Double = 60
        
        
        // economy score based on tanked fuel
        var economyScore: Double {
            if (isFull) {
                let mileage: Double
                if (isMileageOverall) {
                    mileage = mileageAll - (car.millage ?? 0)
                } else {
                    mileage = mileageSinceRefueling
                }
                return ((tankedFuel ?? 1) * 100) / mileage
            } else {
                let mileage: Double
                if isMileageOverall {
                    mileage = mileageAll - (car.millage ?? 0)
                } else {
                    mileage = mileageSinceRefueling
                } 
                return ((tankedFuel ?? 1) * 100) / mileage
            }
        }
        
        var allMileage: Double {
            switch isMileageOverall {
            case true:
                return mileageAll
            case false:
                return mileageSinceRefueling + (car.millage ?? 0 )
            }
        }
        
        let waluta: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")

        
        
        func addRefill(cars: Cars) {
            let refillCounted = FuelEconomy(isFull: isFull, mileageOverall: mileageOverAllCount(), mileageSinceLast: mileageSinceLastRefuelCount(), priceOverall: extractedFunc(), pricePerLiter: extractedFunc1(), tankedFuel: tankedFuel, date: Date.now)

            
            if let indx = cars.cars.firstIndex(where: {$0.id == car.id }) {
                cars.cars[indx].fuel.append(refillCounted)
            }
        }
        
        
        // method to get proper value of fuel price and fuel price per liter when adding to car history
        fileprivate func extractedFunc() -> Double {
            return fuelPerLiterWasChanged ? amountCounted : fuelPrice
        }
        
        fileprivate func extractedFunc1() -> Double {
            return fuelPerLiterWasChanged ? fuelPricePerLiter : amountCounted
        }
        
        // function to add mileage to car history
        func mileageOverAllCount() -> Double {
            if (isMileageOverall) {
                return mileageAll
            } else {
                return mileageSinceRefueling + (car.millage ?? 0)
            }
        }
        func mileageSinceLastRefuelCount() -> Double {
            if (!isMileageOverall) {
                return mileageSinceRefueling
            } else {
                return mileageAll - (car.millage ?? 0 )
            }
        }
    }
}

struct FuelAdd{
    var tanked: Double?
    var pricePerLiter: Double
    var priceAll: Double
}
