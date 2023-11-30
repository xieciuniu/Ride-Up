//
//  AddCarView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import SwiftUI
import PhotosUI

struct AddCarView: View {
    
    // all cars class
    @EnvironmentObject var cars: Cars
    
    // property to store photo
    @State var photo: PhotosPickerItem? = nil
    
    @State private var selectedPhoto: Data? = nil
    
    @State private var newCar = Car()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var descriptionString = ""
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Vehicle") {
                    HStack {
                        Text("Name: ")
                        TextField("", text: $newCar.name)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Make: ")
                        TextField("", text: $newCar.make)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Model: ")
                        TextField("", text: $newCar.model)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                
                Section("Description") {
                    TextEditor(text: $descriptionString)
                    
                }
                
                Section() {
                    HStack{
                        Text("Mileage: ")
                        TextField("0", value: $newCar.millage, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Text("Tank Capacity")
                        Spacer()
                        TextField("0", value: $newCar.tankCapacity, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Chose your units"){
                    HStack {
                        Text("Fuel:")
                        Picker("", selection: $viewModel.fuelUnit) {
                            ForEach(viewModel.fuelUnits, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    HStack {
                        Text("Distance:")
                        Picker("", selection: $viewModel.distanceUnit) {
                            ForEach(viewModel.distanceUnits, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Fuel economy:")
                        Picker("", selection: $viewModel.fuelEconomyUnit) {
                            ForEach(viewModel.fuelEconomyUnits, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                }
                
                Section("Photo") {
                    
                        //here chosen image
                        if let selectedPhoto, let uiImage = UIImage(data: selectedPhoto) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 160)
                                .padding([.leading, .trailing], 90)
                                .padding([.top, .bottom], 15)
                        }
                        
                        
                        PhotosPicker(selection: $photo, matching: .images) {
                            Text(selectedPhoto != nil ? "Change photo" : "Add photo")
                        
                    }
                }
                
                Section("Details") {
                    HStack {
                        Text("Year: ")
                        TextField("", text: $newCar.year)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Fuel type:")
                        // TODO: picker of possible fuel what change engine size and transmision
                    }
                    HStack {
                        Text("Second tank:")
                        
                    }
                    HStack {
                        Text("Engine size:")
                    }
                    HStack {
                        Text("Engine power:")
                    }
                    HStack {
                        Text("Transmission:")
                        // TODO: picker of transmission type
                    }
                    
                    // TODO: think about it is necessary
                    HStack {
                        Text("Vin:")
                    }
                    HStack {
                        Text("License plate:")
                    }
                    HStack {
                        Text("Insurance policy: ")
                    }
                
                }
                
                Button("Add Car") {
                    newCar.description = descriptionString
                    cars.cars.append(newCar)
                    cars.save()
                    dismiss()
                }
            }
            .toolbar {
                Button("Cancel", role: .cancel){
                    dismiss()
                }
            }
        }
        .onChange(of: photo) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedPhoto = data
                    newCar.image = data
                }
            }
        }
    }
}

struct AddCarView_Previews: PreviewProvider {
    static var previews: some View {
        AddCarView()
            .environmentObject(Cars())
    }
}

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

