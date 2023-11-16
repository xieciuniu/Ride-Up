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
                            Text("Custom:")
                            TextField("", text: $viewModel.customPart)
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
                    HStack {
                        if viewModel.selectedPhoto != nil {
                            if let uiImage = UIImage(data: viewModel.selectedPhoto!) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                
                                Spacer()
                            }
                        }
                        PhotosPicker(selection: $viewModel.photo, matching: .images) {
                            Text("Add photo")
                        }
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
            }
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Add") {
                        // method to add repair to car
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
        }
    }
}

struct RepairView_Previews: PreviewProvider {
    static var previews: some View {
        RepairView()
            .environmentObject(Cars())
    }
}
