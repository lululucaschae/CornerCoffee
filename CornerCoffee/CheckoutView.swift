//
//  CheckoutView.swift
//  CornerCoffee
//
//  Created by Lucas Chae on 5/16/22.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: Order
    
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""

    
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.myCoffee.total, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await processOrder()
                    }
                    
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
//        .alert(errorMessage, isPresented: $showingError) {
//            Button("Ok") {
//                Text("Error: \(errorMessage)")
//            }
//        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    func processOrder() async {
        // Encode our order
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        // URL setup
        let url = URL(string: "https://reqres.in/api/coffeeorder")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            // Upload encoded data
            guard let (data, _) = try? await URLSession.shared.upload(for: request, from: encoded) else {
                alertTitle = "Upload failed"
                alertMessage = "Unstalbe internet connection"
                showingAlert = true
                return
            }
            // Getting back uploaded data
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertTitle = "Order complete"
            alertMessage = "Order for \(decodedOrder.myCoffee.name) is on its way!. Total will be \(decodedOrder.myCoffee.total)"
            showingAlert = true
            
        } catch {
            print("Checkout failed")
        }
        
        
        
        
    }
    
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
