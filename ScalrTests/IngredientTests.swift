//
//  IngredientTests.swift
//  ScalrTests
//
//  Created by Michael Heft on 3/13/23.
//

import XCTest
@testable import Scalr

final class IngredientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() throws {
        let flour = Ingredient(name: "flour", pounds: 1, ounces: 10, bakersPercentage: 1)
        let water = Ingredient(name: "water", pounds: 0, ounces: 10, bakersPercentage: 0.625)
        let yeast = Ingredient(name: "yeast", pounds: 0, ounces: 0.5, bakersPercentage: 0.033)
        let salt = Ingredient(name: "salt", pounds: 0, ounces: 0.33, bakersPercentage: 0.022)
        XCTAssertEqual(flour.getPounds(), 16)
        XCTAssertEqual(flour.getOunces(), 0.625)
        XCTAssertEqual(water.getPounds(), 0)
        XCTAssertEqual(water.getOunces(), 0.625)
        XCTAssertEqual(yeast.getPounds(), 0)
        XCTAssertEqual(yeast.getOunces(), 0.5)
        XCTAssertEqual(salt.getPounds(), 0)
        XCTAssertEqual(salt.getOunces(), 0.33)
    }

    func testScale() throws {
        let flours = [Ingredient(name: "flour", pounds: 1, ounces: 0, bakersPercentage: 1)]
        let remaining = [Ingredient(name: "water", pounds: 0, ounces: 10, bakersPercentage: 0.625), Ingredient(name: "salt", pounds: 0, ounces: 0.02, bakersPercentage: 0.022), Ingredient(name: "yeast", pounds: 0, ounces: 0.03, bakersPercentage: 0.033)]
        let desiredPortions: [String:Double] = ["noPortions": 2, "poundsPerPortion": 0, "ouncesPerPortion": 13]
        let scaled = Ingredient.scale(desiredPortionAmounts: desiredPortions, flours: flours, remaining: remaining)
        
        let expected: [String:[String:Double]] = ["flour": ["pounds": 2, "ounces": 10, "bakersPercentage": 1], "water": ["pounds": 1, "ounces": 10, "bakersPercentage": 0.625], "yeast": ["pounds": 0, "ounces": 0.02, "bakersPercentage": 0.033], "salt": ["pounds": 0, "ounces": 0.02, "bakersPercentage": 0.022]]
        
        for (name, amounts) in expected {
            let ingredient = scaled.first(where: {$0.name == name})!
            
            XCTAssertEqual(ingredient.getPounds(), amounts["pounds"]!, "\(name) - pounds")
            XCTAssertEqual(ingredient.getOunces(), amounts["ounces"]!, "\(name) - ounces")
        }
    }
    
    func testCalculatePercentages_Baguettes() throws {
        let flours = [Ingredient(name: "flour", pounds: 1, ounces: 0)]
        let remaining = [Ingredient(name: "water", pounds: 0, ounces: 10), Ingredient(name: "salt", pounds: 0, ounces: 0.33), Ingredient(name: "yeast", pounds: 0, ounces: 0.5)]
        Ingredient.calculatePercentages(flours: flours, remaining: remaining)
        let expected = ["flour": 1, "water": 0.625, "yeast": 0.5, "salt": 0.33]
        
        for ingredient in (flours + remaining) {
            XCTAssertEqual(ingredient.getBakersPercentage(), expected[ingredient.getName()]!)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
