//
//  RefuelHistoryView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 31/10/2023.
//

import Foundation

extension RefuelHistoryView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car = Car()
        
        let economyUnit = "l/100km"
        
        
        func extractCar(cars: Cars) {
            if let thisCar = cars.cars.first(where: {$0.isChosen == true}) {
                car = thisCar
            }
        }
        
        let waluta: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
        
    }
}
