//
//  EditChecklistView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 09/10/2023.
//

import SwiftUI

struct EditChecklistView: View {
    
    @State var itemID: UUID
    @EnvironmentObject var cars: Cars
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    @State var refresher = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Change name"){
                    TextField("", text: $viewModel.item.checkName)
                }
                Section("Change last check") {
                    DatePicker("", selection: $viewModel.item.lastCheck)
                        .datePickerStyle(.automatic)
                        .labelsHidden()
                }
                Section("Interval") {
                    Text(viewModel.item.when.description)
                    
                    HStack {
                        Text("Add year")
                        Spacer()
                        Button("+") { viewModel.plusYear() }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.minusYear() }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Add Month")
                        Spacer()
                        Button("+") { viewModel.plusMonth() }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.minusMonth() }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Add Day")
                        Spacer()
                        Button("+") { viewModel.plusDay() }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.minusDay() }
                            .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Text("Add Hour")
                        Spacer()
                        Button("+") { viewModel.plusHour() }
                            .buttonStyle(.borderedProminent)
                        Button("-") { viewModel.minusHour() }
                            .buttonStyle(.borderedProminent)
                    }
                    Text("minutes only for testing purpose")
                    HStack {
                        Button("+") { viewModel.minutes(1) }
                            .buttonStyle(.borderedProminent)
                        Spacer()
                        Button("-") { viewModel.minutes(-1) }
                            .buttonStyle(.borderedProminent)
                    }
                }
                
                Section("Reminders") {
                    // for each loop that show all added reminders
                    ForEach(viewModel.reminders , id: \.self){ reminder in
                        VStack {
                            HStack {
                                Text(reminder.dateComponents.description)
//                                Text("Before")
                            }
                            VStack {
                                let ind = viewModel.reminders.firstIndex(where: {$0.name == reminder.name}) ?? 0
                                HStack {
                                    Spacer()
                                    
                                    Button("+", action: {viewModel.addYearToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    Text("Year")
                                        .frame(width: 50)
                                    Button("-", action: {viewModel.subYearToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    
                                    Spacer()
                                    
                                     Button("+", action: {viewModel.addMonthToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    Text("Month")
                                        .frame(width: 50)
                                    Button("-", action: {viewModel.subMonthToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    
                                    Spacer()
                                }
                                
                                 HStack {
                                     Spacer()
                                     
                                     Button("+", action: {viewModel.addDayToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    Text("Day")
                                         .frame(width: 50)
                                    Button("-", action: {viewModel.subDayToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    
                                     Spacer()
                                     
                                     Button("+", action: {viewModel.addHourToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    Text("Hour")
                                         .frame(width: 50)
                                    Button("-", action: {viewModel.subHourToReminder(number: ind)})
                                        .buttonStyle(.borderedProminent)
                                    
                                     Spacer()
                                 }
                            }
                        }
                        
                    } .onDelete(perform: { indexSet in
                        viewModel.deleteItem(at: indexSet)
                    })
                    
                    HStack {
                        Text("Add reminder")
                        
                        Spacer()
                        
                        Button("+") {
                            viewModel.addReminder()
                        }
                            .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .toolbar {
            Button("Save") {
                if let idd = viewModel.car.checklist.firstIndex(where: {$0.id == viewModel.item.id }) {
                    viewModel.car.checklist[idd] = viewModel.item
                }
                
                viewModel.saveReminders()
                dismiss()
            }
        }
        .onAppear(perform: {
            viewModel.extract(cars: cars, itemID: itemID)
            viewModel.notNillComponent()
            viewModel.getNotification()
            
        })
    }

}

#Preview {
    EditChecklistView(itemID: UUID())
        .environmentObject(Cars())
}
