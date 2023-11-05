//
//  RefuelEditView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 05/11/2023.
//

import SwiftUI

struct RefuelEditView: View {
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var cars: Cars
    @Environment(\.dismiss) var dismiss
    
    let id: UUID
    
    var body: some View {
        Form {
            Section {
                HStack{
                    Text("Tanked fuel: ")
//                    Spacer()
                    TextField("", value: $viewModel.fuelVariable.tankedFuel , format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("l")
                }
                HStack {
                    Text("Fuel price per liter:")
                    TextField("", value: $viewModel.fuelVariable.pricePerLiter, format: viewModel.waluta)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack{
                    Text("Price for fuel:")
                    TextField("", value: $viewModel.fuelVariable.priceOverall, format: viewModel.waluta)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Odometer when you fill up:")
                    TextField("", value: $viewModel.fuelVariable.mileageOverall, format: .number )
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("km")
                }
                HStack {
                    Text("Mileage since last refill:")
                    TextField("", value: $viewModel.fuelVariable.mileageSinceLast, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("km")
                }
                HStack {
//                    Text("When you fuel up:")
                    DatePicker("When you fuel", selection: $viewModel.date)
//                        .multilineTextAlignment(.trailing)
                }
                
            }
            
        }
        .toolbar{
            Button("Save") {
                // viewModel function to save changes
                viewModel.saveVariable()
                
                if let carIndx = cars.cars.firstIndex(where: {$0.isChosen == true }) {
                    if let thisRefilIndx = cars.cars[carIndx].fuel.firstIndex(where: {$0.id == id }) {
                        cars.cars[carIndx].fuel[thisRefilIndx] = viewModel.fuelVariable
                    }
                }
                cars.save()
                dismiss()
            }
        }
        
        .onAppear(perform: {
            viewModel.extractVariable(cars: cars, id: id)
        })
    }
}

#Preview {
    RefuelEditView(id: UUID())
        .environmentObject(Cars())
}