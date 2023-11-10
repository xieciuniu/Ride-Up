//
//  AddChecklistView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 11/10/2023.
//

import Foundation

extension AddChecklistView {
    @MainActor class ViewModel: ObservableObject {
        // chosen car
        @Published var car: Car = Car()
        func extractCar(cars: Cars) {
            if let chosenCar = cars.cars.first(where: { $0.isChosen }) {
                car = chosenCar
            }
        }
        
        // placeholder for value in CheckListItem struct to append car by it
        @Published var cIName: String = ""
        @Published var cIWhen: DateComponents = DateComponents.init(year: 0, month: 0, day: 0, hour: 0)
        @Published var cILast: Date = Date.now
        
        
        //Date compomnents changers
        func addYear() {
            cIWhen.year! += 1
        }
        func minusYear() {
            if cIWhen.year! > 0 {
                cIWhen.year! -= 1
            }
        }
        func addMonth() {
            if cIWhen.month! < 11 {
                cIWhen.month! += 1
            } else {
                cIWhen.month = 0
                cIWhen.year! += 1
            }
        }
        func minusMonth() {
            if cIWhen.month! > 0 {
                cIWhen.month! -= 1
            }
        }
        func addDay() {
            if cIWhen.day! < 30 {
                cIWhen.day! += 1
            } else {
                cIWhen.day = 0
                cIWhen.month! += 1
            }
        }
        func minusDay() {
            if cIWhen.day! > 0 {
                cIWhen.day! -= 1
            }
        }
        func addHour() {
            if cIWhen.hour! < 23 {
                cIWhen.hour! += 1
            } else {
                cIWhen.hour = 0
                cIWhen.day! += 1
            }
        }
        func minusHour() {
            if cIWhen.hour! > 0 {
                cIWhen.hour! -= 1
            }
        }
        
        
        // add button
        func addCheck() -> CheckListItem {
            return CheckListItem(checkName: cIName, when: cIWhen, lastCheck: cILast)
        }
        
    }
}
