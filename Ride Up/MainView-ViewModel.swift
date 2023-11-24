//
//  MainView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import Foundation
import SwiftUI

extension MainView {
    @MainActor class ViewModel: ObservableObject {
        @EnvironmentObject var cars: Cars
        
        @Published var car = Car()

        @Published var showRefuel = false
        
        @Published var addRemainder = false
        
        @Published var addRepair = false 
        
        // Preview check
        @Published var threeCheckList: [CheckListItem] = [CheckListItem(checkName: "Test check", when: DateComponents(hour: 1), lastCheck: Date.now)]
        
        func extractReminders(car: Car) {
            threeCheckList = []
            
            let sorted = car.checklist.sorted(by: {Calendar.current.date(byAdding: $0.when, to: $0.lastCheck)! < Calendar.current.date(byAdding: $1.when, to: $1.lastCheck)!})
            
            // HERE
            if sorted.count > 3 {
                for i in 0...2 {
                    threeCheckList.append(sorted[i])
                }
            } else if sorted.count > 0 {
                for i in 0..<sorted.count {
                    threeCheckList.append(sorted[i])
                }
            }
        }
        
        func toNextCheck(nextCheck: Date) -> DateComponents {
            let interval = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: Date.now, to: nextCheck)
            if interval < DateComponents(year: 0, month: 0, day: 0, hour: 0) {
                return DateComponents(year: 0, month: 0, day: 0, hour: 0)
                
            }
            return interval
        }
        
        @Published var threeRemainders: [UNNotificationRequest] = [UNNotificationRequest(identifier: "aaa", content: UNNotificationContent(), trigger: nil)]
        
        func getRemainders() {
            self.threeRemainders = []
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { deliveredNotifications in
                DispatchQueue.main.async {
                    var fetchNotification: [UNNotificationRequest] = []
//                    var notificationArray: [UNNotificationRequest] = []
                    for i in deliveredNotifications {
                        if i.identifier.hasSuffix(self.car.id.uuidString) {
                            //title.contains("| " + self.car.name) {
                            fetchNotification.append(i)
                        }
                    }
                    
                    self.extractThree(array: fetchNotification)
                }
            }
        }
        
        // error
        func extractDate(trigger: UNNotificationTrigger) -> Date {
            if let request = trigger as? UNCalendarNotificationTrigger {
                return request.nextTriggerDate() ?? Date.now
            } else { return Date() }
        }
        func extractThree(array: [UNNotificationRequest]) {
            let sortedArray = array.sorted { extractDate(trigger: $0.trigger!) < extractDate(trigger: $1.trigger!) }
            if array.count > 3 {
                for i in 0...2 {
                    self.threeRemainders.append(sortedArray[i])
                }
            } else if array.count > 0 {
                for i in 0..<array.count {
                    self.threeRemainders.append(sortedArray[i])
                }
            }
        }
    }
}
