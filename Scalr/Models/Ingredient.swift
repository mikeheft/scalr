//
//  Ingredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import Foundation

class Ingredient: Equatable {
    private let name: String
    private var pounds: Double
    private var ounces: Double
    private var bakersPercentage: Double
    
    // pounds are stored as ounces
    init(name: String, pounds: Double = 0.0, ounces: Double = 0.0, bakersPercentage: Double = 0.0) {
        self.name = name
        self.pounds = pounds * 16
        self.ounces = ounces
        self.bakersPercentage = bakersPercentage
    }
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.ounces == rhs.ounces && lhs.name == rhs.name && lhs.bakersPercentage == rhs.bakersPercentage
    }
    
    static func scale(desiredPortionAmounts: [String:Double], flours: [Ingredient], remaining: [Ingredient]) -> [IngredientStruct] {
        let scaledFlourIngredients = scaleFlourIngredients(desiredPortionAmounts, flours, remaining)
        let totalFlourWeight = scaledFlourIngredients.reduce(0.0) { $0 + $1.getTotalInOunces() }
        
        let scaledRemaining = remaining.map {
            let newIngredientTotal = totalFlourWeight * round($0.getBakersPercentage() * 1000) / 1000
            let converted = FromDecimal.convert(newIngredientTotal, $0.getName())
            
            return IngredientStruct(name:$0.getName(), pounds: converted.getConvertedPounds(), ounces: converted.getConvertedOunces(), bakersPercentage: $0.getBakersPercentage())
        }
        
        return scaledFlourIngredients + scaledRemaining
    }
    
    static func calculatePercentages(flours: [Ingredient], remaining: [Ingredient]) {
        let flourTotalInOunces = calculateFlourTotal(flours: flours)
        updateFloursPercentages(flours, flourTotalInOunces)
        updateRemainingPercentages(remaining, flourTotalInOunces)
    }
    
    func getBakersPercentage() -> Double {
        return round(bakersPercentage * 1000) / 1000
    }
    
    func getName() -> String {
        return name
    }
    
    func getPounds() -> Double {
        return pounds
    }
    
    func getOunces() -> Double {
        return ounces
    }
    
    func formatted() -> String {
        var strings: [String] = []

        if getPounds() > 0 {
            strings.append(formattedPounds())
        }
        if getOunces() > 0.0 {
            strings.append(formattedOunces())
        }
        strings.append(name)

        return strings.joined(separator: " ")
    }
    
    func formattedPounds() -> String {
        return "\(getPounds() / 16) lbs"
    }
    
    func formattedOunces() -> String {
        if getOunces() == 0.0 {
            return ""
        }

        return "\(getOunces()) oz"
    }
    
    func formattedPercentage() -> String {
        return String(format: "%.2f%%", bakersPercentage * 100.0)
    }
    
    func asFraction() -> Rational {
        return Rational(of: getOunces())
    }
    
    private static func scaleFlourIngredients(_ desiredPortionAmounts: [String:Double],_ flourIngredients: [Ingredient], _ remainingIngredients: [Ingredient]) -> [IngredientStruct] {
        let newTotalFlourWeight = calculateNewFlourTotalWeight(desiredPortionAmounts, flourIngredients, remainingIngredients)
        
        return flourIngredients.map {
            let bakersPercent = $0.getBakersPercentage()
            let newIngredientTotal = newTotalFlourWeight * bakersPercent
            let converted = FromDecimal.convert(newIngredientTotal, $0.getName())
            
            return IngredientStruct(name:$0.getName(), pounds: converted.getConvertedPounds(), ounces: converted.getConvertedOunces(), bakersPercentage: bakersPercent)
        }
    }
    
    private static func calculateNewFlourTotalWeight(_ desiredPortionAmounts: [String:Double],_ flourIngredients: [Ingredient], _ remainingIngredients: [Ingredient]) -> Double {
        let combined = flourIngredients + remainingIngredients
        let totalDesiredWeight = caclulateTotalDesiredWeight(desiredPortionAmounts)
        let totalPercentage = combined.reduce(0.0) { $0 + round($1.getBakersPercentage() * 1000) / 1000 }
        
        return totalDesiredWeight / totalPercentage
    }
    
    private static func caclulateTotalDesiredWeight(_ desiredPortionAmounts: [String:Double]) -> Double {
        let numberOfPortions = desiredPortionAmounts["noPortions"]!
        let poundsPerPortion = desiredPortionAmounts["poundsPerPortion"]!
        let ouncesPerPortion = desiredPortionAmounts["ouncesPerPortion"]!
        
        return ((poundsPerPortion * 16) + ouncesPerPortion) * numberOfPortions
    }
    
    private static func updateFloursPercentages(_ flourIngredients: [Ingredient], _ flourTotalInOunces: Double) {
        flourIngredients.indices.forEach {
            let ingredient = flourIngredients[$0]
            let oz = ingredient.getOunces()
            let lbs = ingredient.getPounds()
            
            ingredient.bakersPercentage = ((lbs + oz) / flourTotalInOunces)
        }
    }
    
    private static func updateRemainingPercentages(_ remainingIngredients: [Ingredient], _ flourTotalInOunces: Double) {
        remainingIngredients.indices.forEach {
            let ingredient = remainingIngredients[$0]
            let percent = ingredient.ounces / flourTotalInOunces
            
            ingredient.bakersPercentage = percent
        }
    }
    
    private static func calculateFlourTotal(flours: [Ingredient]) -> Double {
        flours.reduce(0.0) { acc, flour in acc + (flour.pounds + flour.ounces) }
    }
    
    private static func convertOuncesToWholeNumber(_ oz: Double) -> Double {
        let converted = oz < 1 && oz > 0 ? oz * 16 : oz
        return round(converted * 100) / 100
    }
}
