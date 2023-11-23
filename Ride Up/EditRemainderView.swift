//
//  EditRemainderView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 23/10/2023.
//

import SwiftUI

struct EditRemainderView: View {
    
    @StateObject var viewModel = ViewModel()
    var id: String
    @Binding var notificationArray: [UNNotificationRequest]
    @EnvironmentObject var cars: Cars
    @Environment(\.dismiss) var dismiss
    
    var car: Car {
        if let choosenCar = cars.cars.first(where: {$0.isChosen == true }) {
            return choosenCar
        } else { return Car() }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("", text: $viewModel.titleToChange)
                }
                
                Section("Optional") {
                    TextField("Additional description", text: $viewModel.descriptionToChange)
                }
                
                Section("Date") {
                    DatePicker("Change date", selection: $viewModel.dateToChange)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction, content: {
                Button("Save") {
//                    if let indx = notificationArray.firstIndex(where: {$0.identifier == id }) {
//                        
//                    }
                    
                    // view model function save
                    viewModel.save()
                    dismiss()
                }
            })
        }
        
            .onAppear(perform: {
                viewModel.id = id
                viewModel.notificationArray = notificationArray
                viewModel.chosenCar(car: car)
                viewModel.extractNotification(id: id)
            })
    }
}

//#Preview {
//    
//    let content = UNMutableNotificationContent()
//    // basic notification information
//    content.title =  "title"
//    content.subtitle = "subtitle"
//    content.sound = UNNotificationSound.default
//    
//    let array = [UNNotificationRequest(identifier: "aaa", content: content, trigger: nil)]
//    
//    EditRemainderView(id: "aaa", notificationArray: .constant(array))
//}
