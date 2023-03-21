//
//  FromDecimal.swift
//  Scalr
//
//  Created by Michael Heft on 3/20/23.
//

import Foundation

// Converts total amount into ounces and pounds format, e.g., 1.625 == 1# 10oz
struct FromDecimal {
    var pounds: Double
    var ounces: Double
    var name: String
    
    static func convert(_ total: Double, _ name: String) -> FromDecimal {
        let oz = total.truncatingRemainder(dividingBy: 16)
        let lbs = total - oz
        
        return FromDecimal(pounds: lbs, ounces: oz, name: name)
    }
    
    func getConvertedOunces() -> Double {
        let remainder = ounces.truncatingRemainder(dividingBy: 1)
        if remainder == 0 {
            return ounces
        } else {
            return round(ounces * 100) / 100
        }
    }
    
    func getConvertedPounds() -> Double {
        return pounds / 16
    }
}
