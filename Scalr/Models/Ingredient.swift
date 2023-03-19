//
//  Ingredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import Foundation

class Ingredient: Equatable {
    private let name: String
    private var ounces: Double = 0.0
    private var bakersPercentage: Double = 0.0
    
    // pounds are stored as ounces
    init(name: String, pounds: Double, ounces: Double, bakersPercentage: Double = 0.0) {
        self.name = name
        self.ounces = convertToOunces(pounds: pounds, ounces: ounces)
        self.bakersPercentage = bakersPercentage
    }
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.ounces == rhs.ounces && lhs.name == rhs.name && lhs.bakersPercentage == rhs.bakersPercentage
    }
    
    static func scale(desiredPortionAmounts: [String:Double], flours: [Ingredient], remaining: [Ingredient]) -> [IngredientStruct] {
        let scaledFlourIngredients = scaleFlourIngredients(desiredPortionAmounts, flours, remaining)
        let totalFlourWeight = scaledFlourIngredients.reduce(0.0) { $0 + ($1.getTotalInOunces()) }
        let scaledRemaining = remaining.map {
            let newIngredientTotal = totalFlourWeight * $0.getBakersPercentage()
            
            return IngredientStruct(name:$0.getName(), ounces: newIngredientTotal, bakersPercentage: $0.getBakersPercentage())
        }
        
        return scaledFlourIngredients + scaledRemaining
    }
    
    static func calculatePercentages(flours: [Ingredient], remaining: [Ingredient]) {
        let flourTotalInOunces = calculateFlourTotal(flours: flours)
        updateFloursPercentages(flours, flourTotalInOunces)
        updateRemainingPercentages(remaining, flourTotalInOunces)
    }
    
    func getBakersPercentage() -> Double {
        return bakersPercentage
    }
    
    func getName() -> String {
        return name
    }
    
    func getPounds() -> Double {
        let poundsAndOunces = ounces / 16
        let oz = poundsAndOunces.truncatingRemainder(dividingBy: 1)
        if poundsAndOunces >= 1 {
            return (poundsAndOunces - oz) * 16
        } else {
            return 0
        }
//        poundsAndOunces = poundsAndOunces > 1 ? poundsAndOunces : poundsAndOunces * 16
        
//        return (poundsAndOunces - oz) * 16
    }
    
    func getOunces() -> Double {
        let poundsAndOunces = ounces >= 16 ? ounces / 16 : ounces
        let remainder = poundsAndOunces.truncatingRemainder(dividingBy: 1)
        return remainder > 0 ? remainder : poundsAndOunces / 16
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
            
            return IngredientStruct(name:$0.getName(), ounces: newIngredientTotal, bakersPercentage: bakersPercent)
        }
    }
    
    private static func calculateNewFlourTotalWeight(_ desiredPortionAmounts: [String:Double],_ flourIngredients: [Ingredient], _ remainingIngredients: [Ingredient]) -> Double {
        let combined = flourIngredients + remainingIngredients
        let totalDesiredWeight = caclulateTotalDesiredWeight(desiredPortionAmounts)
        let totalPercentage = combined.reduce(0.0) { $0 + $1.getBakersPercentage() }
        
        return totalDesiredWeight * totalPercentage
    }
    
    private static func caclulateTotalDesiredWeight(_ desiredPortionAmounts: [String:Double]) -> Double {
        let numberOfPortions = desiredPortionAmounts["noPortions"]!
        let poundsPerPortion = desiredPortionAmounts["poundsPerPortion"]!
        let ouncesPerPortion = desiredPortionAmounts["ouncesPerPortion"]!
        
        return (poundsPerPortion + ouncesPerPortion) * numberOfPortions
    }
    
    private static func updateFloursPercentages(_ flourIngredients: [Ingredient], _ flourTotalInOunces: Double) {
        flourIngredients.indices.forEach {
            let ingredient = flourIngredients[$0]
            let ounces = ingredient.ounces
            let convertedOunces = ounces >= 1 ? ounces : ounces * 16
            
            ingredient.bakersPercentage = (convertedOunces / flourTotalInOunces)
        }
    }
    
    private static func updateRemainingPercentages(_ remainingIngredients: [Ingredient], _ flourTotalInOunces: Double) {
        remainingIngredients.indices.forEach {
            let ingredient = remainingIngredients[$0]
            let oz = ingredient.ounces
            let percent = oz < 1 ? oz * 16 : oz
            
            ingredient.bakersPercentage = percent
        }
    }
    
    private static func calculateFlourTotal(flours: [Ingredient]) -> Double {
        flours.reduce(0.0) { acc, flour in acc + flour.ounces }
    }
    
    private static func convertOuncesToWholeNumber(_ oz: Double) -> Double {
        let converted = oz < 1 && oz > 0 ? oz * 16 : oz
        return round(converted * 100) / 100
    }
    
    private func convertPoundsToOunces(_ lbs: Double) -> Double {
        return lbs * 16
    }
    
    private func convertOuncesToPoundsAndOunces() -> Double {
        return ounces / 16
    }
    
    private func convertToOunces(pounds: Double, ounces: Double) -> Double {
        return convertPoundsToOunces(pounds) + ounces
    }
}
