//
//  NewRemainderView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 01/10/2023.
//

import Foundation
import SwiftUI
import UserNotifications

extension NewRemainderView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car = Car()
        
        
        func chosenCar(chosen: Car) {
            car = chosen
        }
        
        // reminder name and description
        @Published var customRemainder = ""
        @Published var optionalDescribe = ""
        
        // Remainder start date
        @Published var starting: String = "Today"
        let startingOptions: [String] = ["Today", "Chose the day"]
        @Published var selectedDate: Date = Date.now
        
        func addRemainder() {
            let content = UNMutableNotificationContent()
            // basic notification information
            content.title =  self.customRemainder + " | " + car.name
            content.subtitle = self.optionalDescribe
            content.sound = UNNotificationSound.default
            
            //when this notification will be triggered
            let trigger = UNCalendarNotificationTrigger(dateMatching:Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate), repeats: false)
            
            // adding identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString + car.id.uuidString, content: content, trigger: trigger)
            
            // add notification request
            UNUserNotificationCenter.current().add(request)
        }
        
        // changing data function
        func year(_ years: Int) {
            if let date = Calendar.current.date(byAdding: .year, value: years, to: selectedDate) {
                self.selectedDate = date
            }
        }
        func month(_ months: Int) {
            if let date = Calendar.current.date(byAdding: .month, value: months, to: selectedDate) {
                self.selectedDate = date
            }
        }
        func day(_ days: Int) {
            if let date = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
                self.selectedDate = date
            }
        }
        func hour(_ hours: Int) {
            if let date = Calendar.current.date(byAdding: .hour, value: hours, to: selectedDate) {
                self.selectedDate = date 
            }
        }
        func minute(_ minutes: Int) {
            if let date = Calendar.current.date(byAdding: .minute, value: minutes, to: selectedDate) {
                self.selectedDate = date
            }
        }
    }
}
