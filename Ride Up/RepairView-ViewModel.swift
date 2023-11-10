//
//  RepairView-ViewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 02/10/2023.
//

import Foundation
import SwiftUI
import UserNotifications
import UIKit
import _PhotosUI_SwiftUI

extension RepairView {
    @MainActor class ViewModel: ObservableObject {
     
        @Published var car = Car()
        
        @Published var typeOfWork: String = "Repair"
        let optionsOfWork: [String] = ["Repair", "Replace"]
        
        @Published var part: String = "Oil"
        @Published var customPart: String = ""
        let carParts: [String] = ["Oil", "tyres", "Suspension", "window", "engine"]
        
        // price
        @Published var priceOfItem: Double? = nil
        @Published var priceOfWork: Double? = nil
        
        // photo picker section
        @Published var photo: PhotosPickerItem? = nil
        @Published var selectedPhoto: Data? = nil
        
    }
}
