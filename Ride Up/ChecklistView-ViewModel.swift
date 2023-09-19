//
//  ChecklistView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 07/10/2023.
//

import Foundation

extension ChecklistView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car = Car()
        
        // func to get chosen car from whole set
        func extractCar(cars: Cars) {
            if let chosenCar = cars.cars.first(where: { $0.isChosen }) {
                car = chosenCar
            } else { car = Car() }
        }
        
        // function to get data and data components
        func nextCheck(lastCheck: Date, when: DateComponents) -> Date? {
            let nextCheck = Calendar.current.date(byAdding: when, to: lastCheck)
            return nextCheck
        }
        
        func toNextCheck(nextCheck: Date, item: CheckListItem) -> DateComponents {
            let interval = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month], from: Date.now, to: nextCheck)
            if interval < DateComponents(year: 0, month: 0, day: 0, hour: 25){
                if let thisItem = car.checklist.firstIndex(where: {$0.id == item.id}) {
                    car.checklist[thisItem].needToCheck = true
                }
                
                if interval < DateComponents(year: 0, month: 0, day: 0, hour: 0) {
                    return DateComponents(year: 0, month: 0, day: 0, hour: 0)
                    
                }
            }
            return interval
        }
        
        // Add screen
        @Published var showEditView = false
        @Published var showAddView = false 
        
        func resetDate(item: CheckListItem, cars: Cars) {
            if let thisItem = car.checklist.firstIndex(where: {$0.id == item.id}) {
                car.checklist[thisItem].lastCheck = Date.now
                car.checklist[thisItem].needToCheck = false
            }
            cars.save()
        }
    }
}
