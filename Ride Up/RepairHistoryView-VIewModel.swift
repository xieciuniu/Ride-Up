//
//  RepairHistoryView-VIewModel.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 20/11/2023.
//

import Foundation

extension RepairHistoryView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var car = Car()
        
    }
}
