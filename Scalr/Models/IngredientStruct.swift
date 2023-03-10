//
//  ScaledIngredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/6/23.
//

import Foundation

struct IngredientStruct {
    private static let POUNDS_IN_OUNCES: Double = 16.0
    static let FLOURS: [String] = [
        "","All Purpose Flour", "Bread Flour", "Cake Flour", "High Gluten Flour", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST", "TEST"
    ]
    let name: String
    var pounds: Double
    var ounces: Double
    var bakersPercentage: Double
    
    static func scale(desiredPortionAmounts: [String:Double], flours: [Ingredient], remaining: [Ingredient]) -> [IngredientStruct] {
        let scaledFlourIngredients = scaleFlourIngredients(desiredPortionAmounts, flours, remaining)
        let totalFlourWeight = scaledFlourIngredients.reduce(0.0) { $0 + ($1.amountTotalInOunces()) }
        let scaledRemaining = remaining.map {
            let newIngredientTotal = totalFlourWeight * $0.getBakersPercentage()
            let ounces = newIngredientTotal.truncatingRemainder(dividingBy: 1)
            let pounds = newIngredientTotal - ounces
            
            return IngredientStruct(name:$0.getName(), pounds: pounds, ounces: ounces, bakersPercentage: $0.getBakersPercentage())
        }
        
        return scaledFlourIngredients + scaledRemaining
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
            string = String((ounces * 100) / 100)
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
    
    // Private Functions
    private static func caclulateTotalDesiredWeight(_ desiredPortionAmounts: [String:Double]) -> Double {
        let numberOfPortions = desiredPortionAmounts["noPortions"]!
        let poundsPerPortion = desiredPortionAmounts["poundsPerPortion"]!
        let ouncesPerPortion = desiredPortionAmounts["ouncesPerPortion"]!
        
        return (poundsPerPortion + (ouncesPerPortion / 16.0)) * numberOfPortions
    }
    
    private static func calculateTotalActualWeight(_ ingredients: [Ingredient]) -> Double {
        return ingredients.reduce(0.0) {$0 + $1.amountTotalInOunces()}
    }
    
    private static func scaleFlourIngredients(_ desiredPortionAmounts: [String:Double],_ flourIngredients: [Ingredient], _ remainingIngredients: [Ingredient]) -> [IngredientStruct] {
        let newTotalFlourWeight = calculateNewFlourTotalWeight(desiredPortionAmounts, flourIngredients, remainingIngredients)
        
        return flourIngredients.map {
            let bakersPercent = $0.getBakersPercentage()
            let newIngredientTotal = newTotalFlourWeight * bakersPercent
            let ounces = newIngredientTotal.truncatingRemainder(dividingBy: 1)
            let pounds = newIngredientTotal - ounces
            
            return IngredientStruct(name:$0.getName(), pounds: pounds, ounces: ounces, bakersPercentage: bakersPercent)
        }
    }
    
    private static func calculateNewFlourTotalWeight(_ desiredPortionAmounts: [String:Double],_ flourIngredients: [Ingredient], _ remainingIngredients: [Ingredient]) -> Double {
        let combined = flourIngredients + remainingIngredients
        let totalDesiredWeight = caclulateTotalDesiredWeight(desiredPortionAmounts)
        let totalPercentage = combined.reduce(0.0) { $0 + $1.getBakersPercentage() }
        
        return totalDesiredWeight / totalPercentage
    }
    
    private func amountTotalInOunces() -> Double {
        return Double(pounds) + Double(ounces)
    }
}

extension Double {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
