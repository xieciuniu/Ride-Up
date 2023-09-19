//
//  NewRemainderView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 01/10/2023.
//

import SwiftUI

struct NewRemainderView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cars: Cars
    
    @StateObject private var viewModel = ViewModel()
    
    var car: Car {
        if let choosenCar = cars.cars.first(where: {$0.isChosen == true }) {
            return choosenCar
        } else { return Car() }
    }
    
    var body: some View {
//        NavigationView {
            Form {
                Section("Reminder name") {
                    TextField("Name", text: $viewModel.customRemainder)
                }
                
                Section("Optional") {
                    TextField("Additional describe", text: $viewModel.optionalDescribe)
                }
                
                // section i think don't needed
//                Section("Start day") {
//                    Picker("when to start", selection: $viewModel.starting) {
//                        ForEach(viewModel.startingOptions, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    
//                    if viewModel.starting == "Chose the day" {
//                        DatePicker("Start of counting", selection: $viewModel.selectedDate)
//                    }
//                }
                
                Section("When it has to remind") {
                    DatePicker("Remind occur ", selection: $viewModel.selectedDate)
                    
                    HStack {
                        Text("Year")
                        Spacer()
                        Button("+") { viewModel.year(1) }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.year(-1) }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Months")
                        Spacer()
                        Button("+") { viewModel.month(1) }
//                            .frame(width: 60)
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.month(-1) }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Day")
                        Spacer()
                        Button("+") { viewModel.day(1) }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.day(-1) }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Hour")
                        Spacer()
                        Button("+") { viewModel.hour(1) }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.hour(-1) }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Minutes")
                        Spacer()
                        Button("+") { viewModel.minute(1) }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.minute(-1) }
                            .buttonStyle(.borderedProminent)
                    }
                }   
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Add") {
                        viewModel.addRemainder()
                        dismiss()
                    }
                })
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Back", role: .destructive) { dismiss() }
//                }
            }
//        }
        
        .onAppear{
            viewModel.chosenCar(chosen: car)
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct NewRemainderView_Previews: PreviewProvider {
    static var previews: some View {
        NewRemainderView()
            .environmentObject(Cars())
    }
}
