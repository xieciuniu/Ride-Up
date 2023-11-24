//
//  ShowRemaindersView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 21/10/2023.
//

import Foundation
import UIKit
import NotificationCenter
import SwiftUI
import UserNotifications

extension ShowRemainderView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car: Car = Car()
        
        func chosenCar(car: Car) {
            self.car = car
        }
        
        @Published var notificationArray: [UNNotificationRequest] = []
        
        func getNotification() {
            UNUserNotificationCenter.current().getPendingNotificationRequests { deliveredNotifications in
                DispatchQueue.main.async {
                    var fetchNotification: [UNNotificationRequest] = []
                    for i in deliveredNotifications {
                        if i.identifier.hasSuffix(self.car.id.uuidString) {
                            fetchNotification.append(i)
                        }
                    }
                    self.notificationArray = fetchNotification
                }
            }
        }
        
        func nextTrigger(trigger: UNNotificationTrigger) -> Date{
            if let request = trigger as? UNCalendarNotificationTrigger {
                return request.nextTriggerDate()!
            } else { return Date()}
        }
        
        func sortArray(one: UNNotificationTrigger, two: UNNotificationTrigger) -> Bool {
            if let request = [one, two] as? [UNCalendarNotificationTrigger] {
                return request[0].nextTriggerDate()! < request[1].nextTriggerDate()!
            } else { return false }
        }
        
        
        // edit notification
        @Published var showEditNotification = false
        
        //deleting notification
        func deleteNotification(id: String) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }
}


