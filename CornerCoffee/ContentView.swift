//
//  ContentView.swift
//  CornerCoffee
//
//  Created by Lucas Chae on 5/16/22.
//
//  Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
//  If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, try commenting out the request.httpMethod = "POST" line in your code, which should force the request to fail.
//  For a more challenging task, see if you can convert our data model from a class to a struct, then create an ObservableObject class wrapper around it that gets passed around. This will result in your class having one @Published property, which is the data struct inside it, and should make supporting Codable on the struct much easier.


import SwiftUI

struct MenuView: View {
@StateObject var order = Order()
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Choose your order", selection: $order.myCoffee.flavor.animation()) {
                        ForEach(Order.flavors.keys.sorted().indices) {index in
                            Text(Order.flavors.keys.sorted()[index])
                        }
                    }
                    .pickerStyle(.menu)
                    Picker("Choose your order", selection: $order.myCoffee.size) {
                        ForEach(Order.sizes.keys.sorted().indices) {index in
                            Text(Order.sizes.keys.sorted()[index])
                        }
                    }
                    .pickerStyle(.segmented)
                    Stepper("Number of orders: \(order.myCoffee.quantity)", value: $order.myCoffee.quantity, in: 1...10)
                } header: {
                    Text("Choose your menu")
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.myCoffee.customOrder.animation())
                    if order.myCoffee.customOrder {
                        if (Order.flavors.keys.sorted()[order.myCoffee.flavor] == "Americano" || Order.flavors.keys.sorted()[order.myCoffee.flavor] == "Latte"){
                            Stepper("Extra shots: \(order.myCoffee.extraShots)", value: $order.myCoffee.extraShots, in: 0...3)
                        }

                        Stepper("Extra syrup: \(order.myCoffee.extraSyrups)", value: $order.myCoffee.extraSyrups, in: 0...3)
                    }
                }
                
                
                Section {
                    NavigationLink {
                        PickupLocationView(order: order)
                    } label: {
                        Text("Place Order")
                    }
                }
            }
            .navigationTitle("Corner Coffee")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
