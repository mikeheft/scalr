//
//  Ingredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import Foundation

class Ingredient {
    let name: String
    var pounds: Int = 0
    var ounces: Float = 0
    var bakersPercentage: Float = 0.0
    
    init(name: String, pounds: Int, ounces: Float, bakersPercentage: Float = 0.0) {
        self.name = name
        self.pounds = pounds
        self.ounces = ounces
        self.bakersPercentage = bakersPercentage
    }
    
    static func scale(flours: [Ingredient], remaining: [Ingredient]) {
        let flourTotalInOunces = flours.reduce(0) { acc, ingredient in acc + ingredient.amountTotalInOunces() }
        updateFlours(flours, flourTotalInOunces)
        updateRemaining(remaining, flourTotalInOunces)
    }
    
    func amountTotalInOunces() -> Float {
        return (Float(pounds) * 16.0) + Float(ounces)
    }
    
    func formatted() -> String {
        var strings: [String] = []
        
        if pounds > 0 {
            strings.append("\(pounds) lbs")
        }
        if ounces > 0.0 {
            strings.append("\(ounces) oz")
        }
        strings.append(name)
        
        return strings.joined(separator: " ")
    }
    
    func formattedPounds() -> String {
        return "\(pounds) lbs"
    }
    
    func formattedOunces() -> String {
        return "\(ounces) oz"
    }
    
    func formattedPercentage() -> String {
        let percentage = bakersPercentage * 100.0
        return String(format: "%.2f%%", percentage)
    }
    
    private static func updateFlours(_ flourIngredients: [Ingredient], _ flourTotalInOunces: Float) {
        flourIngredients.indices.forEach {
            let ingredient = flourIngredients[$0]
            ingredient.bakersPercentage = ingredient.amountTotalInOunces() / flourTotalInOunces
        }
    }
    
    private static func updateRemaining(_ remainingIngredients: [Ingredient], _ flourTotalInOunces: Float) {
        remainingIngredients.indices.forEach {
            let ingredient = remainingIngredients[$0]
            ingredient.bakersPercentage = ingredient.amountTotalInOunces() / flourTotalInOunces
        }
    }
}
