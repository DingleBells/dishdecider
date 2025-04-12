//
//  DishData.swift
//  dishdeciderapp
//
//  Created by Kanghee Cho on 4/11/25.
//

import Foundation

struct Dish: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let imageName: String   // Name of the image file in your assets
    let description: String
    let restaurantName: String
    let price: String
    // Add other relevant details like price, ingredients, etc.
    
    // We don't expect an ID to be stored in the JSON. We generate one when decoding.
    enum CodingKeys: String, CodingKey {
        case name, imageName, description, restaurantName, price
    }
    
    // Initializer for creating new Dish instances in code
    init(name: String, imageName: String, description: String, restaurantName: String, price: String) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.description = description
        self.restaurantName = restaurantName
        self.price = price
    }
    
    // Custom initializer for decoding from JSON — we generate a new UUID here.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.description = try container.decode(String.self, forKey: .description)
        self.restaurantName = try container.decode(String.self, forKey: .restaurantName)
        self.price = try container.decode(String.self, forKey: .price)
    }
}

/// Loads an array of Dish objects from a JSON file named "dishes.json" located in the main bundle.
func loadDishes() -> [Dish] {
    guard let url = Bundle.main.url(forResource: "dishes", withExtension: "json") else {
        print("Could not find dishes.json in the bundle")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let dishes = try decoder.decode([Dish].self, from: data)
        return dishes
    } catch {
        print("Error decoding dishes JSON: \(error)")
        return []
    }
}

// Instead of a hardcoded array, we now load the dishes from our JSON file.
let sampleDishes: [Dish] = loadDishes()
