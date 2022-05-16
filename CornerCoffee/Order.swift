//
//  Order.swift
//  CornerCoffee
//
//  Created by Lucas Chae on 5/16/22.
//

import Foundation
import SwiftUI

class Order: ObservableObject, Codable {
    enum acceptedPropertyKey: CodingKey {
        case myCoffee
    }
    
    static let flavors = ["Espresso": 2, "Americano": 3, "Cold Brew": 3.5, "Latte": 3.5]
    static let sizes = ["Small": 0, "Regular": 0.5, "Large": 1]
    static let locations = ["Camps Bay", "Sandhurst", "Waterfront"]
    
    struct Coffee: Codable {
        var flavor = 0
        var size = 0
        var quantity = 1
        var location = 0
        var name = ""
        var customOrder = false
        var extraShots = 0
        var extraSyrups = 0
        
        var total: Double {
            var price = flavors[flavors.keys.sorted()[flavor]]
            price! += sizes[sizes.keys.sorted()[size]]!
            price = price! * Double(quantity)
            price = Double(price ?? 0)
            
            return price!
        }
    }
    
    @Published var myCoffee = Coffee()
    
    func encode(to encoder: Encoder) throws {
        var keyContainer = encoder.container(keyedBy: acceptedPropertyKey.self)
    
        try keyContainer.encode(myCoffee, forKey: .myCoffee)
    }
    
    required init(from decoder: Decoder) throws {
        let keyContainer = try decoder.container(keyedBy: acceptedPropertyKey.self)
        
        myCoffee = try keyContainer.decode(Coffee.self, forKey: .myCoffee)
    }
    
    init() { }
    
    
}
