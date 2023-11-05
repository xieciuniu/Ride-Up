//
//  RefuelHistoryView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 31/10/2023.
//

import SwiftUI

struct RefuelHistoryView: View {
    @StateObject var viewModel = ViewModel()
    
    @EnvironmentObject var cars: Cars
    var body: some View {
        Form {
            Section{
                ForEach(viewModel.car.fuel, id: \.self) { fuel in
                    
                    NavigationLink {
                        RefuelEditView(id: fuel.id)
                    } label: {
                        VStack{
                            HStack{
                                Text("Tanked: \((fuel.tankedFuel ?? 0.00), specifier: "%.2f") l")
                                Spacer()
                            }
                            HStack {
                                Text(fuel.date?.formatted() ?? Date.now.formatted())
                                Spacer()
                            }
                            HStack {
                                Text("Price \((fuel.priceOverall ?? 0), format: viewModel.waluta)")
                                Spacer()
                            }
                            HStack {
                                Text("Fuel economy: \(fuel.fuelEconomy ?? 5, specifier: "%.2f") \(viewModel.economyUnit)")
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.extractCar(cars: cars)
        })
    }
}

#Preview {
    RefuelHistoryView()
        .environmentObject(Cars())
}
