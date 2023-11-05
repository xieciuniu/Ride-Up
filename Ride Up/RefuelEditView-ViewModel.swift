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
                if let thisRefil = thisCar.fuel.first(where: {$0.id == id }) {
                    fuelVariable = thisRefil
                    date = fuelVariable.date ?? Date.now
                }
            }
        }
        
        func saveVariable(){
            self.fuelVariable.date = date
        }
        
        let waluta: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
        

    }
}
