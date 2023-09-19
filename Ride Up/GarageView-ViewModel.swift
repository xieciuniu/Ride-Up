//
//  GarageView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import Foundation

extension GarageView {
    @MainActor class ViewModel: ObservableObject {
        // adding new car
        @Published var addCar = false
        
        
        
        func choose (car: Car, cars: Cars) {
            objectWillChange.send()
            if let indx = cars.cars.firstIndex(where: {$0.isChosen == true}) { cars.cars[indx].isChosen = false}
            car.isChosen = true
            cars.save()
        }
        func chooseTest (car: Car, cars: [Car]) {
//            objectWillChange.send()
//            if let indx = cars.cars.firstIndex(where: {$0.isChosen == true}) { cars.cars[indx].isChosen = false}
//            car.isChosen = true
//            cars.save()
            cars.forEach{$0.isChosen = false}
            car.isChosen = true
        }
        
    }
}
