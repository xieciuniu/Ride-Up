//
//  AddChecklistView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 11/10/2023.
//

import SwiftUI

struct AddChecklistView: View {
    @EnvironmentObject var cars: Cars
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Name of check:")
                        Spacer()
                        TextField("Name", text: $viewModel.cIName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                Section() {
                    Text("choose interval of check")
                    
                    Text(viewModel.cIWhen.description)
                    
                    HStack {
                        Text("Year:")
                        Spacer()
                        Button("+"){ viewModel.addYear() }
                            .buttonStyle(.borderedProminent)
                            .scaledToFill()
                            .frame(width: 35)
                        Button("-") {
                            viewModel.minusYear()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(width: 35)
                    }
                    
                    HStack {
                        Text("Month:")
                        Spacer()
                        Button("+"){ viewModel.addMonth() }
                            .buttonStyle(.borderedProminent)
                            .scaledToFill()
                            .frame(width: 35)
                        Button("-") {
                            viewModel.minusMonth()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(width: 35)
                        
                    }
                    
                    HStack {
                        Text("Day:")
                        Spacer()
                        Button("+"){ viewModel.addDay() }
                            .buttonStyle(.borderedProminent)
                            .scaledToFill()
                            .frame(width: 35)
                        Button("-") {
                            viewModel.minusDay()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(width: 35)
                    }
                    
                    HStack {
                        Text("Hour:")
                        Spacer()
                        Button("+"){ viewModel.addHour() }
                            .buttonStyle(.borderedProminent)
                            .scaledToFill()
                            .frame(width: 35)
                        Button("-") {
                            viewModel.minusHour()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(width: 35)
                    }
                }
                
                Section {
                    DatePicker("Last check", selection: $viewModel.cILast)
                    
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigation, content: {
                    Button("Cancel") { dismiss()}
                })
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Add") {
                        if let carID = cars.cars.firstIndex(where: {$0.isChosen == true}) {
                            cars.cars[carID].checklist.append(viewModel.addCheck())
                        }
                        cars.save()
                        dismiss()
                    }
                })
            }
        }
    }
}

#Preview {
    AddChecklistView()
        .environmentObject(Cars())
}
