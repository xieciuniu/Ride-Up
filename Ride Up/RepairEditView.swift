//
//  RepairEditView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 21/11/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct RepairEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cars: Cars
    
    @StateObject var viewModel = ViewModel()
    
    var car: Car {
        if let chosen = cars.cars.first(where: {$0.isChosen == true }) {
            return chosen
        } else { return Car()}
    }
    
    var repairID: UUID
    
    var body: some View {
        Form {
            // Textfield to change: partName, recipePhoto, priceOfItem, priceOfWork, dateOfRepair
            HStack {
                Text("Name of part: ")
                TextField("", text: $viewModel.name)
                    .multilineTextAlignment(.trailing)
            }
            
            if (viewModel.dataPhoto != nil ) {
                if let uiImage = UIImage(data: viewModel.dataPhoto!) {
                    HStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding([.leading, .trailing], 90)
                            .padding([.top, .bottom], 30)
                            .contextMenu {
                                Button {
                                    let imageSaver = ImageSaver()
                                    // Add image to Photos
                                    imageSaver.writeToPhotoAlbum(image: uiImage)
                                } label: {
                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                                }
                            }
                    }
                }
            }
            HStack {
                PhotosPicker(selection: $viewModel.photo, matching: .images) {
                    Text(viewModel.dataPhoto != nil ? "Change photo" : "Add photo")
                }
            }
            
            HStack {
                Text("Price of part:")
                Spacer()
                TextField("", value: $viewModel.priceOfItem, format: .number)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Text("Mileage when happened:")
                TextField("", value: $viewModel.mileageWhen, format: .number)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Price of work:")
                Spacer()
                TextField("", value: $viewModel.priceOfWork, format: .number)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                DatePicker("Change date", selection: $viewModel.date)
            }
            
        }
        
        .toolbar{
            ToolbarItem(content: {
                Button("Save") {
                    if let carIndx = cars.cars.firstIndex(where: {$0.isChosen == true }) {
                        if let repairIndx = cars.cars[carIndx].repairStruct.firstIndex(where: {$0.id == repairID }) {
                            cars.cars[carIndx].repairStruct[repairIndx] = viewModel.save(id: repairID)
                        }
                    }
                    cars.save()
                    dismiss()
                }
            })
        }
        
        .onAppear(perform: {
            viewModel.car = car
            viewModel.getThisRepair(id: repairID)
        })
        
        .onChange(of: viewModel.photo) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.dataPhoto = data
                }
            }
        }
    }
}

#Preview {
    RepairEditView(repairID: UUID())
        .environmentObject(Cars())
}
