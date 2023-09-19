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
                        Text("Here user can change old refilling")
                    } label: {
                        VStack{
                            HStack{
                                Text("\(fuel.fuelEconomy, specifier: "%.2f")")
                                Spacer()
                            }
                            HStack {
                                Text(fuel.date?.formatted() ?? Date.now.formatted())
                                Spacer()
                            }
                            HStack {
                                Text("\((fuel.price ?? 0), format: viewModel.waluta)")
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
