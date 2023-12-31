//
//  RepairView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 02/10/2023.
//

import SwiftUI
import PhotosUI

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
            Form {
                Section() {
                    Toggle("Custom name: ", isOn: $viewModel.isCustom)
                }
                
                // correct way it show name of section
                Section("Part") {
                    if (viewModel.isCustom) {
                        HStack {
                            Text("Name:")
                            TextField("", text: $viewModel.part)
                                .multilineTextAlignment(.trailing)
                        }
                    } else {
                        Picker("Part:", selection: $viewModel.part) {
                            ForEach(viewModel.carParts, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                }
                
                Section("recipe photo"){
                    if viewModel.selectedPhoto != nil {
                        if let uiImage = UIImage(data: viewModel.selectedPhoto!) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding([.leading, .trailing], 90)
                                .padding([.top, .bottom], 30)
                        }
                    }
                    PhotosPicker(selection: $viewModel.photo, matching: .images) {
                        Text(viewModel.selectedPhoto != nil ? "Change photo": "Add photo")
                    }
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
                
                Section("Mileage") {
                    HStack {
                        Text("Mileage when happened:")
                        TextField("", value: $viewModel.mileageWhen, format: .number)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Date") {
                    DatePicker("When ", selection: $viewModel.dateOfRepair)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Add") {
                        // method to add repair to car
                        if let thisCar = cars.cars.firstIndex(where: {$0.isChosen == true}) {
                            cars.cars[thisCar].repairStruct.append(viewModel.createRepairStruct())
                        }
                        cars.save()
                        dismiss()
                    }
                }
            }
            
            .onChange(of: viewModel.photo) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        viewModel.selectedPhoto = data
                    }
                }
            }
        
        .onAppear{
            viewModel.car = car
            if let mileage = car.millage {
                viewModel.mileageWhen = mileage
            }
        }
    }
}

struct RepairView_Previews: PreviewProvider {
    static var previews: some View {
        RepairView()
            .environmentObject(Cars())
    }
}
