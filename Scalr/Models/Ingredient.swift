//
//  Ingredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import Foundation

class Ingredient {
    let name: String
    var pounds: Double = 0.0
    var ounces: Double = 0.0
    var bakersPercentage: Double = 0.0
    
    init(name: String, pounds: Double, ounces: Double, bakersPercentage: Double = 0.0) {
        self.name = name
        self.pounds = pounds
        self.ounces = convertToDecimalIfRequired(ounces)
        self.bakersPercentage = bakersPercentage
    }
    
    static func calculatePercentages(flours: [Ingredient], remaining: [Ingredient]) {
        let flourTotalInOunces = calculateFlourTotal(flours: flours)
        updateFloursPercentages(flours, flourTotalInOunces)
        updateRemainingPercentages(remaining, flourTotalInOunces)
    }
    
    func amountTotalInOunces() -> Double {
        return Double(pounds) + ounces
    }
    
    func formatted() -> String {
        var strings: [String] = []
        
        if pounds > 0 {
            strings.append(formattedPounds())
        }
        if ounces > 0.0 {
            strings.append(formattedOunces())
        }
        strings.append(name)
        
        return strings.joined(separator: " ")
    }
    
    func formattedPounds() -> String {
        return "\(pounds) lbs"
    }
    
    func formattedOunces() -> String {
        if ounces == 0.0 {
            return ""
        }
        var string: String = ""
        let remainder = ounces.truncatingRemainder(dividingBy: 1)
        if remainder < 1 && remainder > 0 {
            string = String(ounces * 16)
        } else {
            string = String(Int(ounces))
        }
        return string + " oz"
    }
    
    func formattedPercentage() -> String {
        return String(format: "%.2f%%", bakersPercentage * 100.0)
    }
    
    func asFraction() -> Rational {
        let total = pounds + ounces
        return Rational(of: total)
    }
    
    private static func updateFloursPercentages(_ flourIngredients: [Ingredient], _ flourTotalInOunces: Double) {
        flourIngredients.indices.forEach {
            let ingredient = flourIngredients[$0]
            ingredient.bakersPercentage = (ingredient.amountTotalInOunces() / flourTotalInOunces)
        }
    }
    
    private static func updateRemainingPercentages(_ remainingIngredients: [Ingredient], _ flourTotalInOunces: Double) {
        remainingIngredients.indices.forEach {
            let ingredient = remainingIngredients[$0]
            ingredient.bakersPercentage = (ingredient.amountTotalInOunces() / flourTotalInOunces)
        }
    }
    
    private static func calculateFlourTotal(flours: [Ingredient]) -> Double {
        flours.reduce(0.0) { acc, flour in acc + flour.amountTotalInOunces() }
    }
    
    private func convertToDecimalIfRequired(_ ounces: Double) -> Double {
        return ounces >= 1 ? ounces / 16.0 : ounces
    }
}
