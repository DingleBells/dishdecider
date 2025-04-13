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
    let imageURL: String // Changed imageName to imageURL and type to String
    let description: String
    let restaurantName: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case name, imageURL, description, restaurantName, price
    }

    init(name: String, imageURL: String, description: String, restaurantName: String, price: String) {
        self.id = UUID()
        self.name = name
        self.imageURL = imageURL
        self.description = description
        self.restaurantName = restaurantName
        self.price = price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
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
        return try decoder.decode([Dish].self, from: data)
    } catch {
        print("Error decoding dishes JSON: \(error)")
        return []
    }
}

// Instead of a hardcoded array, we now load the dishes from our JSON file.
let sampleDishes: [Dish] = loadDishes()
