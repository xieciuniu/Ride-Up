//
//  ContentView.swift
//  Ride Up
//
//  Created by Hubert Wojtowicz on 19/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    // property to store cars
    @StateObject var cars = Cars()
    
    var body: some View {
        TabView {
            Group {
                // home view
                MainView()
                .tabItem {
                    Label("Home Screen", systemImage: "house")
                }
                
                // second - report view
                // this one is probably to kick out
//                ReportView()
//
//                .tabItem{
//                        Label("Report", systemImage: "list.bullet.clipboard")
//                }
                
                // my garage
                GarageView()
                    .tabItem {
                        Label("My Garage", systemImage: "car")
                    }
                
                // tips for car / calendar
                TipsView()
                    .tabItem {
                        Label("Tip", systemImage:"wrench.and.screwdriver")
                    }
                
                
                // map for gas station / car mechanic
                MapView()
                    .tabItem {
                        Label("Map", systemImage:"mappin")
                    
                }
            }
        }
        .environmentObject(cars)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
