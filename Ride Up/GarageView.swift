//
//  GarageView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import SwiftUI

struct GarageView: View {
    
    @EnvironmentObject var cars: Cars
    
    @State private var exampleCars: [Car]
    
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                // for design purpose
                ForEach(cars.cars) { car in
//                ForEach(exampleCars) { car in
//                    Section("\(car.name)") {
                    
                    ZStack{
                        
                        if car.isChosen {
                            
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(car.isChosen ? .blue : .white, lineWidth: 4)
                            //                            .fill(car.isChosen ? .blue : .white)
                            //                            .fill(.background)
                                .contentShape(Rectangle())
                                .frame(height: 120)
                        }
                            
                        RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
//                        .opacity(0.1)
                        .contentShape(Rectangle())
                        .frame(height: 120)
                        
                    VStack{
                        Text(car.name)
//                            .padding(.bo)
                                
                                HStack {
                                    if car.image != nil {
                                        Image(uiImage: UIImage(data: car.image!)!)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .frame(width: 110, height: 70)
                                            .padding(.leading, 5)
                                    } else {
                                        Image(systemName: "car")
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .frame(width: 110, height: 70)
                                            .padding(.leading, 5)
                                    }
                                        
                                    Spacer()
                                    
                                    VStack {
                                        Text(car.make)
                                        Text(car.model)
                                    }
                                    .padding(.trailing, 30)
                                    
                                }
                                .padding(.horizontal, 10)
                            }

                    }
                        .padding()
                        .ignoresSafeArea()
//                        .background(car.isChosen ? .blue : .white)
                    
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.choose(car: car, cars: cars)
                        viewModel.chooseTest(car: car, cars: exampleCars)
                    }
                }
                //.onDelete(perform: cars.deleteCar)
            }
 
            .background(Color(UIColor.systemGray6))
            
            .sheet(isPresented: $viewModel.addCar) {
                AddCarView()
            }
            
            .toolbar {
                // Button to show sheet that add new car
                Button("add car") {
                    viewModel.addCar.toggle()
                }
            }
        }
    }
    init() {
        let uiImage = UIImage(named: "Mercedes")
        let dataImage = uiImage?.jpegData(compressionQuality: 1.0)
        
        let carOne = Car()
        carOne.name = "Audi"; carOne.make = "Audi"; carOne.model = "A4"
        
        let carTwo = Car()
        carTwo.name = "Meraś"; carTwo.make = "Mercedes"; carTwo.model = "G63";
        carTwo.image = dataImage
        
        let carThree = Car()
        let carFour = Car()
        let carFive = Car()
        let carSix = Car()
        let carSeven = Car()
        let carEight = Car()
        let carNine = Car()
        let carTen = Car()
        
        exampleCars = [carOne, carTwo, carThree, carFour, carFive, carSix, carSeven, carEight, carNine, carTen]
    }
}

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        GarageView()
            .environmentObject(Cars())
    }
}
