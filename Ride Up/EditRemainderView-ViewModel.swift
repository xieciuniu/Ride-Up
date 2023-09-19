//
//  EditRemainderView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 23/10/2023.
//

import Foundation
import UserNotifications

extension EditRemainderView {
    @MainActor class ViewModel: ObservableObject {
        @Published var id: String = ""
        
        @Published var notificationArray: [UNNotificationRequest] = []
        
        @Published var car: Car = Car()
        
        func chosenCar(car: Car) {
            self.car = car
        }
        
        @Published var thisNotification = UNNotificationRequest(identifier: "aaa", content: UNNotificationContent(), trigger: nil)
        @Published var titleToChange = ""
        @Published var descriptionToChange = ""
        @Published var dateToChange = Date()
        
        func extractNotification(id: String) {
            if let notif = notificationArray.first(where: {$0.identifier == id }) {
                thisNotification = notif
                titleToChange = notif.content.title.replacingOccurrences(of: "| \(car.name)", with: "")
                descriptionToChange = notif.content.subtitle
                
                if let trigerDate = notif.trigger as? UNCalendarNotificationTrigger {
                    dateToChange = trigerDate.nextTriggerDate()!
                }
            }
        }
        
        func save() {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            
            let content = UNMutableNotificationContent()
            content.title =  titleToChange + " | \(car.name)"
            content.subtitle = descriptionToChange
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching:Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateToChange), repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString + car.name, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}
