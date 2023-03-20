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
    
    static func convert(_ total: Double) -> FromDecimal {
        let fromDecimal = total / 16.0
        let oz = fromDecimal.truncatingRemainder(dividingBy: 1)
        let lbs = fromDecimal - oz
        
        return FromDecimal(pounds: lbs, ounces: oz)
    }
    
    func getConvertedOunces() -> Double {
        return ounces * 16
    }
    
    func getConvertedPounds() -> Double {
        return pounds
    }
}
