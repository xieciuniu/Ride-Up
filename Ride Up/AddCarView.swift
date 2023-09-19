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
    
    var body: some View {
        NavigationView {
            Form {
                Section("Vehicle") {
                    TextField("Name", text: $newCar.name)
                    TextField("Make", text: $newCar.make)
                    TextField("Model", text: $newCar.model)
                    
                }
                
                Section("fuel") {
                    TextField("year", text: $newCar.year)
                }
                
                Section("Photo") {
                    HStack {
                        //here chosen image
                        if let selectedPhoto, let uiImage = UIImage(data: selectedPhoto) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $photo, matching: .images) {
                            Text("Add photo")
                        }
                    }
                }
                
                Section("Details") {
                    TextField("Millage", value: $newCar.millage, format: .number)
                        .keyboardType(.numberPad)
                
                    HStack{
                        Text("Tank Capacity")
                        Spacer()
                        TextField("0", value: $newCar.tankCapacity, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 30)
                    }
                }
                
                Button("Add Car") {
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

