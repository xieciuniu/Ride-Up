//
//  RepairEditView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 21/11/2023.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI

extension RepairEditView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car = Car()
        
        var thisRepair: RepairStruct = RepairStruct(dateOfRepair: Date.now, partName: "test", mileageWhen: 0)
        
        func getThisRepair(id: UUID) {
            if let repair = car.repairStruct.first(where: {$0.id == id}) {
                thisRepair = repair
                name = thisRepair.partName
                dataPhoto = thisRepair.recipePhoto
                priceOfItem = thisRepair.priceOfItem
                priceOfWork = thisRepair.priceOfWork
                date = thisRepair.dateOfRepair
                mileageWhen = thisRepair.mileageWhen
            }
        }
        
        @Published var name: String = ""
        @Published var dataPhoto: Data? = nil
        @Published var photo: PhotosPickerItem? = nil
        @Published var priceOfItem: Double? = nil
        @Published var priceOfWork: Double? = nil
        @Published var date: Date = Date.now
        @Published var mileageWhen: Double = 0
        
        func save(id: UUID) -> RepairStruct {
            let repair: RepairStruct = RepairStruct(id: id, dateOfRepair: date, partName: name, recipePhoto: dataPhoto, priceOfItem: priceOfItem, priceOfWork: priceOfWork, mileageWhen: mileageWhen)
            
            return repair
        }
    }
}
