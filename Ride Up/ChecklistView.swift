//
//  ChecklistView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 07/10/2023.
//

import SwiftUI

struct ChecklistView: View {
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var cars: Cars
    @Environment(\.dismiss) var dismiss
    @State var reload = 1
    
    var body: some View {

            Form {
                ForEach(viewModel.car.checklist.sorted(by: {Calendar.current.date(byAdding: $0.when, to: $0.lastCheck)! < Calendar.current.date(byAdding: $1.when, to: $1.lastCheck)!}), id: \.self) { item in
                    Section {
                        HStack {
                            ZStack{
                                VStack{
                                    HStack {
                                        Text(item.checkName)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("last check: \(String(item.lastCheck.formatted(date: .omitted, time: .complete)))")
                                        Spacer()
                                    }
                                    
                                    if let nextCheck = viewModel.nextCheck(lastCheck: item.lastCheck, when: item.when){
                                        HStack{
                                            Text("Next check : \(nextCheck.formatted())")
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Text("To next check: \(viewModel.toNextCheck(nextCheck: nextCheck, item: item).description)")
                                            Spacer()
                                        }
                                    }
                                }
                                NavigationLink("", destination: EditChecklistView(itemID: item.id))
                                    .opacity(0)
                            }

                            // do something about it, to work without this crapy line
                            if reload > 0 {}
                            
                            
                            Spacer()
                            
                            Button("O") {
                                viewModel.resetDate(item: item, cars: cars)
                                if let idd = viewModel.car.checklist.firstIndex(where: {$0.id == item.id }) {
                                    viewModel.car.checklist[idd].lastCheck = Date.now
                                }
                                reload += 1
                            }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                        }
                    }
                    .listRowBackground(item.needToCheck == true ? Color.yellow : Color.white)
                    
                }
                .onDelete(perform: { indexSet in
                    cars.deleteItem(at: indexSet)
                })
            }
            .toolbar {
                ToolbarItem{
                    Button("Add") { viewModel.showAddView = true }
                }
            }

        
        .sheet(isPresented: $viewModel.showAddView, content: {
            AddChecklistView()
        })
        
        .onAppear{
            viewModel.extractCar(cars: cars)
        }
//        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ChecklistView()
        .environmentObject(Cars())
}
