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
    var scaled: Bool = true
    
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
    }
    
    func getOunces() -> Double {
       return round(ounces * 100) / 100
    }
    
    func getFormattedPounds() -> String {
        var lbs = getPounds()
        
        if !scaled {
            lbs /= 16
        }
        
        return "\(lbs) lbs"
    }
    
    func getFormattedOunces() -> String {
        let oz = getOunces()
        if oz == 0.0 {
            return ""
        }
        var string: String = ""
        let remainder = oz.truncatingRemainder(dividingBy: 1)
        if remainder > 0 {
            string = String((oz * 100) / 100)
        } else {
            string = String(Int(oz))
        }
        return string + " oz"
    }
    
    func formattedPercentage() -> String {
        return String(format: "%.2f%%", bakersPercentage * 100.0)
    }
    
    // Pounds are converted back to ounces in order to properly add together with ounces to
    // get the total weight
    func getTotalInOunces() -> Double {
        return (pounds * 16) + ounces
    }
}

extension Double {
    func rounded(_ digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

