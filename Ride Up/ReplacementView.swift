//
//  ReplacementView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 04/10/2023.
//

import SwiftUI

struct ReplacementView: View {
    @EnvironmentObject var cars: Cars
    
    @StateObject var viewModel = ViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Chose replacement type", selection: $viewModel.replacingPart) {
                        ForEach(viewModel.replacablePart, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Optional") {
                    HStack {
                        Text("Milage now")
                        Spacer()
                        TextField("0", value: $viewModel.milageNow, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text("km")
                    }
                    
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("0.00", value: $viewModel.changePrice, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Receipt")
                        // picker to add here
                    }

                }
                
                Section("must be"){
                    // Text("picker to chose between next replace by time / milage / time or milage")
                    Picker("Chose type of replacement", selection: $viewModel.replaceType) {
                        ForEach(viewModel.replaceTypes , id: \.self ){
                            Text($0)
                        }
                    } .pickerStyle(.segmented)
                    
                    
                    //                    Text("Here will be recommended value based of user car, with note it is only recommended by me")
                    
                    HStack {
                        Text("Recommended interval based of car model")
                    }
                    
                    
                    //                    Text("depending on what was chosen user can input time, milage or both")

                    if viewModel.replaceType != "Time" {
                          HStack {
                              Text("Interval of milage")
                              Spacer()
                              TextField("0.0", value: $viewModel.milageInterval, format: .number)
                                  .keyboardType(.decimalPad)
                                  .multilineTextAlignment(.trailing)
                              Text("km")
                          }
                      }
                      
                      // time interval
                    if viewModel.replaceType != "Milage"{
                          HStack {
                              Text("Interval of time")
                              Spacer()
    //                          Spacer()
                              TextField("0", value: $viewModel.timeInterval, format: .number)
                                  .keyboardType(.numberPad)
                                  .multilineTextAlignment(.trailing)
                                  .frame(width: 80)
                              Button(viewModel.timeUnit) {
                                  viewModel.timeUnitDialog = true
                              }
                              .buttonStyle(.bordered)
                              .frame(width: 85)
                          }
                      }
                  }
                    

                
                Button("Confirm"){
                    //
                    dismiss()
                }
            }
        }
        .confirmationDialog("Select time unit", isPresented: $viewModel.timeUnitDialog) {
            Button("Days") { viewModel.timeUnit = "Days" }
            Button("Months") { viewModel.timeUnit = "Months" }
            Button("Years") { viewModel.timeUnit = "Years" }
            
            Button("cancel", role: .cancel) {}
        }
        .onAppear{
            viewModel.extractCar(cars: cars)
        }
    }
}

struct ReplacementView_Previews: PreviewProvider {
    static var previews: some View {
        ReplacementView()
            .environmentObject(Cars())
    }
}
