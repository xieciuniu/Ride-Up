//
//  MainView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import SwiftUI

// this view is showing chosen car, allow user to add filling up, show details about car, upcoming events like change of oil, mot 

struct MainView: View {
    
    // add view model
    @StateObject private var viewModel = ViewModel()
    
    @State private var car: Car = Car()
    
    @EnvironmentObject var cars: Cars
    
    var averageEconomy: Double {
        var average: Double = 0
        var numberOfIteration: Double = 0
        
        for item in car.fuel {
            if (item.fuelEconomy != nil) {
                average += item.fuelEconomy!
                numberOfIteration += 1
            }
        }
        if numberOfIteration == 0 { return average }
        
        return average/numberOfIteration
    }
    
    var body: some View {
        NavigationStack {
            Form {
                

                VStack{
                    Text(car.name)
                        .multilineTextAlignment(.center)
                   
                   
                   if car.image != nil {
                       Image(uiImage: UIImage(data: car.image!)!)
                           .resizable()
                           .scaledToFit()
                           .frame(height: 150)
                           .padding(.horizontal, 50)
                   }
                }
                
                Section("Fuel economy") {
                    if !car.fuel.isEmpty {
                        HStack {
                            Text("Average:")
                            Spacer()
                            Text("\(averageEconomy, specifier: "%.2f") l/100km")
                        }
                        
                        HStack {
                            Text("Last:")
                            Spacer()
                            Text("\(car.fuel.last?.fuelEconomy ?? 0, specifier: "%.2f") l/100km")
                        }
                        
                        // add later
                        HStack {
                            Text("Price per km")
                            Spacer()
                        }
                    }
                    
                    Button("Refuel") {
                        viewModel.showRefuel = true
                    }

                    if (!car.fuel.isEmpty){
                        NavigationLink {
                            RefuelHistoryView()
                        } label: {
                            Text("History")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                Section("Checklist") {
                    ForEach(viewModel.threeCheckList) { reminder in
                        ZStack {
                            NavigationLink(destination: ChecklistView(), label: {
                                Text("")
                            })
                            .opacity(0)
                            
                            VStack {
                                Text(reminder.checkName)
                                    .padding(.bottom, 7)
                                Text(viewModel.toNextCheck(nextCheck: reminder.nextCheck).description)
                                    .font(.caption)
                            }
                        }
                        .listRowBackground(reminder.needToCheck == true ? Color.yellow : Color.white)

                    }
                    
                    NavigationLink {
                        ChecklistView()
                    } label: {
                        Text("Checklist")
                            .foregroundStyle(.blue)
                    }
                }
                
                Section("Reminders") {
                    ForEach(viewModel.threeRemainders, id:\.self){ reminder in
                        let reminderName = reminder.content.title.replacingOccurrences(of: "| \(car.name)", with: "")
                        ZStack{
                            VStack {
                                HStack {
                                    Text(reminderName)
                                    Spacer()
                                }
                                if reminder.trigger != nil {
                                    HStack {
                                        Text(viewModel.extractDate(trigger: reminder.trigger!).formatted())
                                        Spacer()
                                    }
                                }
                            }
                            
                            NavigationLink{
                                ShowRemainderView()
                            } label:{
                                
                            }
                        }
                    }
                    
                    NavigationLink {
                        ShowRemainderView()
                    } label: {
                        Text("Show Remainders")
                            .foregroundStyle(.blue)
                    }
                    
                    NavigationLink{
                        NewRemainderView()
                    } label: {
                        Text("Add remainder")
                            .foregroundStyle(.blue)
                    }
                }
                
                
                Section("Repairs") {
                    NavigationLink{
                        RepairView()
                    } label: {
                        Text("Add Repair")
                            .foregroundStyle(.blue)
                    }
                    
                    // next tab with repairs
                    NavigationLink {
                        ForEach(1..<10){
                            Text(String($0))
                        }
                    } label: {
                        Text("Repair History")
                            .foregroundStyle(.blue)
                    }
                }
            }
                        
            .sheet(isPresented: $viewModel.showRefuel){
                RefuelView(car: $car)
            }
//            .sheet(isPresented: $viewModel.addRemainder) {
//                NewRemainderView()
//            }
//            .sheet(isPresented: $viewModel.addRepair) {
//                RepairView()
//            }
            
            .onAppear() {
                if let choosenCar = cars.cars.first(where: {$0.isChosen == true}) {
                    car = choosenCar
                    viewModel.car = choosenCar
                } else { return car = Car()}
                
                viewModel.extractReminders(car: car)
                viewModel.getRemainders()
            }
//            .scrollContentBackground(.hidden)
//            .background(Color.indigo)
//            .ignoresSafeArea()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Cars())
    }
}
