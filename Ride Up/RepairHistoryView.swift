//
//  RepairHistoryView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 20/11/2023.
//

import SwiftUI

struct RepairHistoryView: View {
    @EnvironmentObject var cars: Cars
    @StateObject var viewModel = ViewModel()
    var car: Car {
        if let chosen = cars.cars.first(where: {$0.isChosen == true}) {
            return chosen
        } else { return Car() }
    }
    
    var body: some View {
        Form{
            ForEach(car.repairStruct) { repair in
                VStack {
                    Text(repair.partName)
                    Text(repair.dateOfRepait.description)
                    if repair.recipPhoto != nil{
                        if let uiImage = UIImage(data: repair.recipPhoto!) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            
//                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.car = car
        })
    }
}

#Preview {
    RepairHistoryView()
        .environmentObject(Cars())
}
