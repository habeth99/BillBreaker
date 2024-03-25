//
//  ContentView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/22/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            ZStack {
                // Background color for the entire form
                Rectangle()
                    .foregroundColor(Color(red: 155.0 / 255.0, green: 70.0 / 255.0, blue: 224.0 / 255.0))
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the entire background
                
                // Your form
                Form {
                    Section {
                        NavigationLink(destination: BreakABillView()) {
                            HStack {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 50))
                                    .padding()
                                    .foregroundColor(.orange)
                                Spacer()
                                Text("Break a Bill!")
                                    .rotation3DEffect(
                                        .degrees(45), // Angle in degrees
                                        axis: (x: 1.0, y:0.0, z: 0.0)
                                    )
                                    .font(.system(size: 35))
                                    .fontWidth(.expanded)
                            }
                        }
                        .listRowBackground(Color(red: 155.0 / 255.0, green: 100.0 / 255.0, blue: 224.0 / 255.0)) // This sets the row background to purple
                    }
                    Section{
                        NavigationLink(destination:JoinBillView()) {
                            HStack {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 50))
                                    .padding()
                                    .foregroundColor(.orange)
                                Spacer()
                                Text("Join Bill")
                                    .rotation3DEffect(
                                        .degrees(45), // Angle in degrees
                                        axis: (x: 1.0, y:0.0, z: 0.0)
                                    )
                                    .font(.system(size: 35))
                                    .fontWidth(.expanded)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color(red: 155.0 / 255.0, green: 100.0 / 255.0, blue: 224.0 / 255.0)) // This sets the row background to purple
                    }
                    Section{
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .padding()
                                .foregroundColor(.orange)
                            Spacer()
                            Text("My Bills")
                                .rotation3DEffect(
                                    .degrees(45), // Angle in degrees
                                    axis: (x: 1.0, y:0.0, z: 0.0)
                                )
                                .font(.system(size: 35))
                                .fontWidth(.expanded)
                            Spacer()
                        }
                        .listRowBackground(Color(red: 155.0 / 255.0, green: 100.0 / 255.0, blue: 224.0 / 255.0)) // This sets the row background to purple
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

