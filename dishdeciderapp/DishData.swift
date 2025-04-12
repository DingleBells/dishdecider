//
//  DishData.swift
//  dishdeciderapp
//
//  Created by Kanghee Cho on 4/11/25.
//

import Foundation

struct Dish: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String // Name of the image file in your assets
    let description: String
    let restaurantName: String
    // Add other relevant details like price, ingredients, etc.
}

let sampleDishes: [Dish] = [
    Dish(name: "Chicken Croffle",
         imageName: "SweetMaple_ChickenCroffle",
         description: "Crispy chicken with signature croissant waffle, fruits, candied walnut and spicy honey maple syrup—$25",
         restaurantName: "Sweet Maple Cafe"
        ),
    
    Dish(name: "Kids Pancake",
         imageName: "SweetMaple_KidsPancake",
         description: "With a slice of bacon or pork-lime or a chicken-mango sausage, one egg scrambled-$15",
         restaurantName: "Sweet Maple Cafe"
        ),
    
    Dish(name: "Loco Moco",
         imageName: "SweetMaple_LocoMoco",
         description: "Wagyu beef cutlet, bell pepper, mushroom, onion, egg, rice, gravy-$26",
         restaurantName: "Sweet Maple Cafe"),
    
    Dish(name: "Matcha Moffle",
         imageName: "SweetMaple_MatchaMoffle",
         description: "Matcha mochi waffle, signature matcha lava-$17",
         restaurantName: "Sweet Maple Cafe"),
    
    Dish(name: "Tornado Galbi Omurice",
         imageName: "SweetMaple_TornadoGalbiOmurice",
         description: "Twisted scrambled egg over galbi & vegetable fried rice, demi-glace-$26",
         restaurantName: "Sweet Maple Cafe")
    // Add more dishes here
]
