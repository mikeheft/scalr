//
//  Ingredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import Foundation

struct Ingredient {
    let name: String
    var pounds: Int = 0
    var ounces: Int = 0
    var bakersPercentage: Float = 0.0
    
    func formatted() -> String {
        var strings: [String] = []
        
        if pounds != 0 {
            strings.append("\(pounds) lbs")
        }
        if ounces != 0 {
            strings.append("\(ounces) oz")
        }
        strings.append(name)
        
        return strings.joined(separator: " ")
    }
    
    func formattedPercentage() -> String {
        return String(format: "%.2f %", bakersPercentage)
    }
}
