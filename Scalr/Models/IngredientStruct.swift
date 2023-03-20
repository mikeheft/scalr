//
//  ScaledIngredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/6/23.
//

import Foundation

struct IngredientStruct {
    private static let POUNDS_IN_OUNCES: Double = 16.0
    static let FLOURS: [String] = ["","All Purpose Flour", "Bread Flour", "Cake Flour", "High Gluten Flour"]
    let name: String
    var pounds: Double
    var ounces: Double
    var bakersPercentage: Double
    
    func asFraction(fraction: Double) -> String {
        switch fraction {
        case 0.125..<0.126:
             return NSLocalizedString("\u{215B}", comment: "1/8")
         case 0.25..<0.26:
             return NSLocalizedString("\u{00BC}", comment: "1/4")
         case 0.33..<0.34:
             return NSLocalizedString("\u{2153}", comment: "1/3")
         case 0.5..<0.6:
             return NSLocalizedString("\u{00BD}", comment: "1/2")
         case 0.66..<0.67:
             return NSLocalizedString("\u{2154}", comment: "2/3")
         case 0.75..<0.76:
             return NSLocalizedString("\u{00BE}", comment: "3/4")
         default:
            return "\(fraction)"
        }
    }
    
    func getName() -> String {
        return name
    }
    
    func getPounds() -> Double {
        return pounds
//        let poundsAndOunces = ounces / 16
//        let oz = poundsAndOunces.truncatingRemainder(dividingBy: 1)
//        if poundsAndOunces >= 1 {
//            return poundsAndOunces - oz
//        } else {
//            return 0
//        }
    }
    
    func getOunces() -> Double {
        return ounces * 16
//        var finalOunces = ounces
//        if ounces >= 16 {
//            let lbs = ounces / 16
//            let oz = lbs.truncatingRemainder(dividingBy: 1)
//            finalOunces = oz * 16
//        }
//
//        return round(finalOunces * 100) / 100
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

