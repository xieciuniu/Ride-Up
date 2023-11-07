//
//  RefuelView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 24/09/2023.
//

import SwiftUI

struct RefuelView: View {
    @EnvironmentObject var cars: Cars
    
    @Binding var car: Car
    
    @StateObject var viewModel = ViewModel()
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            Form {

                Section("Refil type"){
                    Picker("Refil type", selection: $viewModel.refillType) {
                        ForEach(viewModel.refillOptions, id: \.self) { key in
                            Text(key)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if (!viewModel.isFull) {
                    Section ("Fuel Tank Status"){
                        HStack {
                            VStack{
                                VStack {
                                    Text("Before refuelling")
                                    Picker("Status", selection: $viewModel.tankStatusBefore) {
                                        ForEach(0..<8){
                                            Text("\(viewModel.tankStatuses[$0])")
                                                .tag(Double($0))
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    
                                    HStack {
                                        Text("|0")
                                        Spacer()
                                        Text("1/2")
                                        Spacer()
                                        Text("1|")
                                    }
                                }
                                .padding(.bottom)
                                
                                VStack{
                                    Text("After fuelling")
                                    
                                    Picker("Status", selection: $viewModel.tankStatus) {
                                        ForEach(1..<9){
                                            Text("\(viewModel.tankStatuses[$0])")
                                                .tag(Double($0))
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    
                                    HStack {
                                        Text("|0")
                                        Spacer()
                                        Text("1/2")
                                        Spacer()
                                        Text("1|")
                                    }
                                }
                            }
                        }
                    }
                }
                
                // test section
                Section("tank capacity test") {
                    Text("tank capacity of this car is \(car.tankCapacity)")
                }
                
                Section("Fuel") {
                    HStack {
                        Text("How much fuel")
                        
                        Spacer()
                        
                        TextField("0", value: $viewModel.tankedFuel, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Double(car.tankCapacity) >= (viewModel.tankedFuel ?? 1) ? .primary : .red)
                        Text("l")
                    }
                    
                    HStack {
                        Text("Fuel price per liter")
                            .foregroundStyle(viewModel.fuelPerLiterWasChanged ?  .primary : .secondary)
                        Spacer()
                        TextField("0.00", value: $viewModel.fuelPricePerLiter, format: viewModel.waluta)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(viewModel.fuelPerLiterWasChanged ?  .primary : .secondary)
                            .onTapGesture(perform: {
                                viewModel.fuelPerLiterWasChanged = true
                                viewModel.perLiterChanged()
                            })
                    }
                    
                     //Over all price, probably will be removed
                    HStack {
                        Text("Fuel priace")
                            .foregroundStyle(viewModel.fuelPerLiterWasChanged ? .secondary : .primary)
                        Spacer()
                        TextField("123.23", value: $viewModel.fuelPrice, format: viewModel.waluta)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(viewModel.fuelPerLiterWasChanged ? .secondary : .primary)
                            .onTapGesture(perform: {
                                viewModel.fuelPerLiterWasChanged = false
                                viewModel.overallChanged()
                            })
                    }
                    
                    HStack{
                        withAnimation{
                            Text(viewModel.fuelPerLiterWasChanged ? "Fuel price" : "Fuel Price per liter")
                        }
                            Spacer()
                        withAnimation {
                            Text("\(viewModel.amountCounted, specifier: "%.2f")")
                        }
                    }
                }
                
                Group{
                    Section("Millage") {
                        
                        VStack {
                            HStack{
                                Spacer()
                                Text("Mileage")
                                Spacer()
                            }
                            
                            Picker("mileage", selection: $viewModel.mileageOption) {
                                ForEach(viewModel.mileageOptions, id:\.self) { optionn in
                                    Text(optionn)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        if (viewModel.isMileageOverall) {
                            HStack {
                                Text("Millage overall")
                                Spacer()
                                TextField("1233.45", value: $viewModel.mileageAll, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                Text("km")
                            }
                        } else {
                            HStack {
                                Text("Millage since last refueling")
                                Spacer()
                                TextField("123.45", value: $viewModel.mileageSinceRefueling, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 60)
                                Text("km")
                            }
                        }
                    }
                }
                
                Group{
                    Section {
                        if (viewModel.isFull) {
                            HStack {
                                Text("your fuel economy score:")
                                Spacer()
                                Text("\(viewModel.economyScore, specifier: "%.2f") l/100km")
                            }
                        } else {
                            HStack {
                                Text("Approximate fuel economy")
                                Spacer()
                                Text("\(viewModel.economyScore, specifier: "%.2f") l/100km")
                            }
                        }
                        
                    }
                }
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Add") {
//                        addRefile()
                        viewModel.addRefill(cars: cars)
                        if let thisCar = cars.cars.first(where: {$0.isChosen == true }) {
                            thisCar.millage = viewModel.mileageOverAllCount()
                        }
                        cars.save()
                        dismiss()
                    }
                }
            }
            
            .onChange(of: viewModel.fuelPrice) { _ in
                viewModel.overallChanged()
            }
            .onChange(of: viewModel.fuelPricePerLiter) { _ in
                viewModel.perLiterChanged()
            }
            .onChange(of: viewModel.tankedFuel) { _ in
                viewModel.tankedWasChanged()
            }
            .onAppear(perform: {
                viewModel.extractCar(cars: cars)
            })
        }
    }                   
    
//    func addRefile() {
//        // add economy score
////        car.fuel.fuelEconomy.append(economyScore)
//        
//        // change mileage of car
//        if mileageOption == "Overall" {
//            car.millage = mileageAll
//        } else {
//            let overall = millageSinceRefueling + (car.millage ?? 0)
//            car.millage = overall
//        }
//    }
    
    init(car: Binding<Car>) {
        self._car = car
    }
}

struct RefuelView_Previews: PreviewProvider {
    static var previews: some View {
        let carExample = Car()
        RefuelView(car: .constant(carExample))
            .environmentObject(Cars())
    }
}
