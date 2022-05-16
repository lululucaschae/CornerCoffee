//
//  PickupLocationView.swift
//  CornerCoffee
//
//  Created by Lucas Chae on 5/16/22.
//

import SwiftUI

struct PickupLocationView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                List {
                    Text("Menu: \(Order.flavors.keys.sorted()[order.myCoffee.flavor])")
                    Text("Size: \(Order.sizes.keys.sorted()[order.myCoffee.size])")
                    Text("Count: \(order.myCoffee.quantity)")
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Custom Order: ")
                        Text(order.myCoffee.customOrder ? "Extra Shots: \(order.myCoffee.extraShots), Extra Syrup \(order.myCoffee.extraSyrups)" : "None")
                    }
                }
            } header: {
                Text("Order detail")
                    .font(.headline)
            }
            Section{
                Picker("Choose your location", selection: $order.myCoffee.location) {
                    ForEach(Order.locations.indices) {index in
                        Text(Order.locations[index])
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Choose store location")
            }
            Section {
                TextField("Name", text: $order.myCoffee.name)
            } header: {
                Text("Personal info")
            }
            
            Section {
                NavigationLink{
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
        }
        .navigationTitle("Confirm your order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PickupLocationView_Previews: PreviewProvider {
    static var previews: some View {
        PickupLocationView(order: Order())
    }
}
