//
//  Ingredient.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import Foundation

struct Ingredient {
    var pounds: Int = 0
    var ounces: Int = 0
    let name: String
    
    func formatted() -> String {
        return "\(pounds) lbs \(ounces) oz - \(name)"
    }
}
