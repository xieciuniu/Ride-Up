//
//  RepairView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 02/10/2023.
//

import SwiftUI

struct RepairView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var cars: Cars
    
    var car: Car {
        if let chosen = cars.cars.first(where: {$0.isChosen == true}) {
            return chosen
        } else { return Car() }
    }
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                
                Section("Type of work") {
                    Picker("repair/change", selection: $viewModel.typeOfWork) {
                        ForEach(viewModel.optionsOfWork, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // correct way it show name of section
                Section("Which part was \(viewModel.typeOfWork)") {
                    Picker("Part:", selection: $viewModel.part) {
                        ForEach(viewModel.carParts, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section("recipe photo"){
                    // photo of recipe for probably future needs
                }
                
                Section("Price") {
                    HStack {
                        Text("Price of item")
                        Spacer()
                        TextField("0.00", value: $viewModel.priceOfItem, format: .number )
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Price of work")
                        Spacer()
                        TextField("0.00", value: $viewModel.priceOfWork, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Add") {
                        // method to add repair to car
                        dismiss()
                    }
                }
            }
            
        }
        .onAppear{
            viewModel.car = car
        }
    }
}

struct RepairView_Previews: PreviewProvider {
    static var previews: some View {
        RepairView()
            .environmentObject(Cars())
    }
}
