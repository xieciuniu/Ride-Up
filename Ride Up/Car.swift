//
//  Car.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import Foundation
import SwiftUI

struct RepairStruct: Codable, Hashable, Identifiable {
    var id = UUID()
    var dateOfRepait: Date
    var partName: String
    var recipPhoto: Data?
    var priceOfItem: Double?
    var priceOfWork: Double?
}

struct FuelEconomy: Codable, Hashable {
    var id = UUID()

    var fuelEconomy: Double? {
        if (isFull) {
            if let fuel = tankedFuel {
                if let sinceLast = mileageSinceLast {
                    return (fuel * 100) / sinceLast
                }
            }
        }
        return nil
    }
    
    var isFull: Bool = true
    
    var isMileageOverallChanged: Bool?
    var mileageBefore: Double?
    var mileageOverall: Double?
    var mileageSinceLast: Double?
    
    var isPricePerLiterChanged: Bool?
    var priceOverall: Double?
    var pricePerLiter: Double?
    
    var tankedFuel: Double?
    
    var date: Date?
}

struct Notification: Codable {
    var type: String = ""
    var description: String = ""
    var date: Date = Date.now
    
}

struct CheckListItem: Codable, Identifiable, Hashable {
    var id = UUID()
    var checkName: String
    var when: DateComponents
    var lastCheck: Date
    var needToCheck: Bool = false
    var nextCheck: Date {
        if let next = Calendar.current.date(byAdding: when, to: lastCheck) {
            return next
        } else { return Date.now }
    }
    
    init(checkName: String, when: DateComponents, lastCheck: Date?) {
        self.checkName = checkName
        self.when = when
        self.lastCheck = lastCheck ?? Date.now
    }
    static func < (lhs: CheckListItem, rhs: CheckListItem) -> Bool {
        let now = Date.now
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs.when, to: now)! < calendar.date(byAdding: rhs.when, to: now)!
    }
}

class Car: Identifiable, Comparable, Codable {
    
    // Identifiable
    var id = UUID()
    
    //car basic information
    var make: String = ""
    var model: String = ""
    var name: String = ""
    var year: String = ""
    var image: Data? = nil
    var description: String = ""
    var distanceUnit: String = ""
    var note: String = ""
    var vin: String = ""
    var licensePlate: String = ""
    var insurancePolicy: String = ""
    var isChosen: Bool = false
    
    // fuel things
    var millage: Double? = nil
    var fuelUnit: String = ""
    var tankCapacity: Int = 0
    var fuelType: String = ""
    var tankLevel: Int = 0
    var fuelEconomy: Double = 0.0
    var fuel: [FuelEconomy] = []
    
    // technical inspection
    var technicalInspection: Date? = nil
    var expirationOfInspection: Double = 0
    var nextTechnicalInspection: Date? {
        technicalInspection?.addingTimeInterval(expirationOfInspection) ?? nil
    }
    
    // oil service property
    var lastOilService: Date? = nil
    var oilServiceInterval: Double = 0
    var nextOilService: Date? = nil
    
    // CheckList
    var checklist: [CheckListItem] = [
        CheckListItem(checkName: "Engine Oil", when: DateComponents.init(day: 7), lastCheck: nil),
        CheckListItem(checkName: "Tire Pressure and Condition", when: DateComponents.init(month: 1), lastCheck: nil),
        CheckListItem(checkName: "Lights", when: DateComponents.init(month: 1), lastCheck: nil),
        CheckListItem(checkName: "Battery", when: DateComponents.init(month: 6), lastCheck: nil),
        CheckListItem(checkName: "Spare Tire", when: DateComponents.init(month: 6), lastCheck: nil),
        CheckListItem(checkName: "Fast line", when: DateComponents.init(day: 10), lastCheck: nil)
    ]
    var repairStruct: [RepairStruct] = []
    
    // Comparable
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Car, rhs: Car) -> Bool {
        return lhs.name < rhs.name
    }
    
}

@MainActor class Cars: ObservableObject {
    @Published var cars: [Car] = []
    
    let saveKey = "SavedPlaces"
    
    func save() {
        do {
            let data = try JSONEncoder().encode(cars)
            try data.write(to: FileManager.documentDirectory.appendingPathComponent(saveKey))
        } catch {
            print("Unable to save")
        }
    }
    
    init() {
        do{
            let data = try Data(contentsOf: FileManager.documentDirectory.appendingPathComponent(saveKey))
            cars = try JSONDecoder().decode([Car].self, from: data)
        } catch {
            cars = []
        }
    }
    
    // deleting car
   func deleteCar(at offsets: IndexSet) {
       cars.remove(atOffsets: offsets)
       
       save()
    }
    
    func deleteItem(at offsets: IndexSet) {
        if let car = cars.first(where: {$0.isChosen == true}) {
            car.checklist.remove(atOffsets: offsets)
        }
    }
    
}

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}
