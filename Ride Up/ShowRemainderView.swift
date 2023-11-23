//
//  ShowRemainderView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 21/10/2023.
//

import SwiftUI

struct ShowRemainderView: View {
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var cars: Cars
    
    var car: Car {
        if let choosenCar = cars.cars.first(where: {$0.isChosen == true }) {
            return choosenCar
        } else { return Car() }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    
                    ForEach(viewModel.notificationArray.sorted { viewModel.sortArray(one: $0.trigger!, two: $1.trigger!) }, id: \.self) {
                        
                        let remainder = $0.content.title.replacingOccurrences(of: "| \(car.name)", with: "")
                        let id = $0.identifier
                        let time = viewModel.nextTrigger(trigger: $0.trigger!)
                        
                        NavigationLink {
                            EditRemainderView(id: id, notificationArray: $viewModel.notificationArray)
                        } label: {
                            VStack {
                                HStack{
                                    Text(remainder)
                                    Spacer()
                                }
                                HStack{
                                    Text(time.formatted())
                                    Spacer()
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive){
                                    viewModel.deleteNotification(id: id)
                                } label: {
                                    Image(systemName: "trash")
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Reminders")
            .toolbar{
                ToolbarItem(placement: .confirmationAction, content: {
                    NavigationLink{
                        NewRemainderView()
                    } label: {
                        Text("Add")
                            .foregroundStyle(.blue)
                    }
                })
            }
        }

        .onAppear(perform: {
            viewModel.chosenCar(car: car)
            viewModel.getNotification()
        })
    }
}

#Preview {
    ShowRemainderView()
        .environmentObject(Cars())
}
