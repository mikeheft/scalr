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
    var ounces: Double
    var bakersPercentage: Double
    
    func getName() -> String {
        return name
    }
    
    func getPounds() -> Double {
        return fromDecimal() - remainingOunces()
    }
    
    func getOunces() -> Double {
        return round(remainingOunces() * 16)
    }
    
    private func fromDecimal() -> Double {
        return ounces / 16
    }
    
    private func remainingOunces() -> Double {
        return fromDecimal().truncatingRemainder(dividingBy: 1)
    }
    
    func getFormattedPounds() -> String {
        let fromDecimal = ounces >= 16 && ounces != 0 ? ounces / 16 : ounces
        let oz = fromDecimal.truncatingRemainder(dividingBy: 1)
        let string = String(format: "%.0f", fromDecimal - oz)
        return "\(string) lbs"
    }
    
    func getFormattedOunces() -> String {
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
    
    func getTotalInOunces() -> Double {
        return ounces
    }
    
    func asFraction() -> Rational {
        let total = 0 + ounces
        return Rational(of: total)
    }
}

extension Double {
    func rounded(_ digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

