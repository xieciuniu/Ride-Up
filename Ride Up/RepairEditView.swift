//
//  RepairEditView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 21/11/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct RepairEditView: View {
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
            
            HStack {
                if (viewModel.dataPhoto != nil ) {
                    if let uiImage = UIImage(data: viewModel.dataPhoto!) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                    }
                    Spacer()
                    
                    PhotosPicker(selection: $viewModel.photo, matching: .images) {
                        Text("Change photo")
                    }
                } else {
                    PhotosPicker(selection: $viewModel.photo, matching: .images) {
                        Text("Add photo")
                    }
                }
            }
            
            HStack {
                Text("Price of part:")
                Spacer()
                TextField("", value: $viewModel.priceOfItem, format: .number)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Price of work:")
                Spacer()
                TextField("", value: $viewModel.priceOfItem, format: .number)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                DatePicker("", selection: $viewModel.date)
            }
            
        }
        .onAppear(perform: {
            viewModel.car = car
            viewModel.getThisRepair(id: repairID)
        })
    }
}

#Preview {
    RepairEditView(repairID: UUID())
        .environmentObject(Cars())
}
