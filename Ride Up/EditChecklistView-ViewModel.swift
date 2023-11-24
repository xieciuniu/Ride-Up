//
//  EditChecklistView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 12/10/2023.
//

import Foundation
import UserNotifications

extension EditChecklistView {
    @MainActor class ViewModel: ObservableObject {
     
        @Published var car = Car()
        @Published var item = CheckListItem(checkName: "empty", when: DateComponents.init(year: 0,month: 0, day: 0 ,hour: 0), lastCheck: nil)
        
        // func to extract
        func extract(cars: Cars, itemID: UUID) {
            if let thisCar = cars.cars.first(where: {$0.isChosen == true}) {
                car = thisCar
                if let thisItem = car.checklist.first(where: {$0.id == itemID}) {
                    item = thisItem 
                }
            }
        }
        
        // function to add/minus
        func plusYear() {
                item.when.year! += 1
        }
        func minusYear() {
            if item.when.year != nil {
                if item.when.year! > 0 {
                    item.when.year! -= 1
                }
            }
        }
        
        func plusMonth() {
            if item.when.month! < 11 {
                item.when.month! += 1
            } else {
                item.when.month = 0
                item.when.year! += 1
            }
        }
        func minusMonth() {
            if item.when.month != nil {
                if item.when.month! > 0 {
                    item.when.month! -= 1
                }
            }
        }
        
        func plusDay() {
            if item.when.day! < 30 {
                item.when.day! += 1
            } else {
                item.when.day = 0
                item.when.month! += 1
            }
        }
        func minusDay() {
            if item.when.day != nil {
                if item.when.day! > 0 {
                    item.when.day! -= 1
                }
            }
        }
        
        func plusHour() {
            if item.when.hour! < 23 {
                item.when.hour! += 1
            } else {
                item.when.hour = 0
                item.when.day! += 1
            }
        }
        func minusHour() {
            if item.when.hour != nil {
                if item.when.hour! > 0 {
                    item.when.hour! -= 1
                }
            }
        }
        func minutes(_ number: Int) {
            if item.when.minute != nil {
                item.when.minute! += number
            } else { item.when.minute = number}
        }
        
        // Reminders Section
        @Published var reminders: [RemainderStruct] = []
        var numberOfRedminder: Int = 0
        
        
        func addReminder() {
            numberOfRedminder += 1
            reminders.append(RemainderStruct(dateComponents: item.when, name: numberOfRedminder))
        }
        
        func addYearToReminder(number: Int) {
            reminders[number].dateComponents.year! += 1
        }
        func subYearToReminder(number: Int) {
            if reminders[number].dateComponents.year! > 0 {
                reminders[number].dateComponents.year! -= 1
            }
        }
        
        func addMonthToReminder(number: Int) {
            if (reminders[number].dateComponents.month! < 11){
                reminders[number].dateComponents.month! += 1
            } else {
                reminders[number].dateComponents.month! = 0
                reminders[number].dateComponents.year! += 1
            }
        }
        func subMonthToReminder(number: Int) {
            if reminders[number].dateComponents.month! > 0 {
                reminders[number].dateComponents.month! -= 1
            }
        }
        
        func addDayToReminder(number: Int) {
            if (reminders[number].dateComponents.day! < 30) {
                reminders[number].dateComponents.day! += 1
            } else {
                reminders[number].dateComponents.day! = 0
                reminders[number].dateComponents.month! += 1
            }
        }
        func subDayToReminder(number: Int) {
            if reminders[number].dateComponents.day! > 0 {
                reminders[number].dateComponents.day! -= 1
            }
        }
        
        func addHourToReminder(number: Int) {
            if (reminders[number].dateComponents.hour! < 23) {
                reminders[number].dateComponents.hour! += 1
            } else {
                reminders[number].dateComponents.hour! = 0
                reminders[number].dateComponents.day! += 1
            }
        }
        func subHourToReminder(number: Int) {
            if reminders[number].dateComponents.hour! > 0 {
                reminders[number].dateComponents.hour! -= 1
            }
        }
        
        
        
        func notNillComponent() {
            if (item.when.year == nil) {
                item.when.year = 0
            }
            if (item.when.month == nil) {
                item.when.month = 0
            }
            if (item.when.day == nil) {
                item.when.day = 0
            }
            if (item.when.hour == nil) {
                item.when.hour = 0
            }
        }
        
        
        // delete item
        func deleteItem(at offsets: IndexSet) {
            reminders.remove(atOffsets: offsets)
        }
        
        
        // adding reminder to notification
        
        func addRemainder(oneReminder: RemainderStruct) {
            let dateOfReminder = selectDate(reminder: oneReminder)
            let content = UNMutableNotificationContent()
            content.title = self.item.checkName + " | " + car.name
            // there won't be any subtitle ??
//            content.subtitle
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching:Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateOfReminder), repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString + item.checkName + car.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
        }
        
        // function to get date from component
        func selectDate(reminder: RemainderStruct) -> Date {
            let lastCheckDate = item.lastCheck
            if let dateOfReminder = Calendar.current.date(byAdding: reminder.dateComponents, to: lastCheckDate){
                return dateOfReminder
            } else {
                return Date.now
            }
        }
        
        // function to add notification request
        func saveReminders() {
            for i in reminders {
                addRemainder(oneReminder: i)
            }
        }
        
        
        //getting notification
        var notificationArray: [UNNotificationRequest] = []
        
        func getNotification() {
            UNUserNotificationCenter.current().getPendingNotificationRequests { deliveredNotifications in
                DispatchQueue.main.async {
                    var fetchNotification: [UNNotificationRequest] = []
                    for i in deliveredNotifications {
                        if i.identifier.hasSuffix(self.item.checkName + self.car.name) {
                            fetchNotification.append(i)
                        }
                    }
                    self.notificationArray = fetchNotification
                }
            }
            for i in notificationArray {
                getNotificationIntoView(i)
            }
        }
        
        func getNotificationIntoView(_ oneNotification: UNNotificationRequest) {
            numberOfRedminder += 1
            if let trigger = oneNotification.trigger {
                let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: Date.now, to: nextTrigger(trigger: trigger))
                reminders.append(RemainderStruct(dateComponents: components, name: numberOfRedminder))
            }
        }
        
        func nextTrigger(trigger: UNNotificationTrigger) -> Date{
            if let request = trigger as? UNCalendarNotificationTrigger {
                return request.nextTriggerDate()!
            } else { return Date()}
        }
    }
}

struct RemainderStruct: Hashable {
    var dateComponents: DateComponents
    var name: Int
}
