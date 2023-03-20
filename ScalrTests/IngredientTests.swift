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
        XCTAssertEqual(flour.getPounds(), 1)
        XCTAssertEqual(flour.getOunces(), 0.625)
        XCTAssertEqual(water.getPounds(), 0)
        XCTAssertEqual(water.getOunces(), 0.625)
        XCTAssertEqual(yeast.getPounds(), 0)
        XCTAssertEqual(yeast.getOunces(), 0.03125)
        XCTAssertEqual(salt.getPounds(), 0)
        XCTAssertEqual(salt.getOunces(), 0.020625)
    }

    func testScale_Lean() throws {
        let flours = [Ingredient(name: "flour", pounds: 1, ounces: 0, bakersPercentage: 1)]
        let remaining = [Ingredient(name: "water", pounds: 0, ounces: 10, bakersPercentage: 0.625), Ingredient(name: "salt", pounds: 0, ounces: 0.33, bakersPercentage: 0.022), Ingredient(name: "yeast", pounds: 0, ounces: 0.5, bakersPercentage: 0.033)]
        let desiredPortions: [String:Double] = ["noPortions": 4, "poundsPerPortion": 0, "ouncesPerPortion": 13]
        let scaled = Ingredient.scale(desiredPortionAmounts: desiredPortions, flours: flours, remaining: remaining)
        let expected: [String:[String:Double]] = [
            "flour": ["pounds": 1, "ounces": 14.95, "bakersPercentage": 1], // 2#
            "water": ["pounds": 1, "ounces": 3.35, "bakersPercentage": 0.625], // 1# 4oz
            "yeast": ["pounds": 0, "ounces": 1.02, "bakersPercentage": 0.033], // 1oz
            "salt": ["pounds": 0, "ounces": 0.68, "bakersPercentage": 0.022]] // 0.75oz
         
        assertScaled(scaled: scaled, expected: expected)
    }
    
    func testScale_Soft() throws {
        let flours = [Ingredient(name: "flour", pounds: 1, ounces: 12)]
        let remaining = [
            Ingredient(name: "water", pounds: 0, ounces: 11),
            Ingredient(name: "yeast", pounds: 0, ounces: 0.66),
            Ingredient(name: "milk", pounds: 0, ounces: 6),
            Ingredient(name: "butter", pounds: 0, ounces: 2),
            Ingredient(name: "sugar", pounds: 0, ounces: 1),
            Ingredient(name: "salt", pounds: 0, ounces: 0.5)
        ]
        let desiredPortions: [String:Double] = ["noPortions": 32, "poundsPerPortion": 0, "ouncesPerPortion": 2]
        Ingredient.calculatePercentages(flours: flours, remaining: remaining)
        let scaled = Ingredient.scale(desiredPortionAmounts: desiredPortions, flours: flours, remaining: remaining)
        let expected: [String:[String:Double]] = [
            "flour": ["pounds": 2, "ounces": 4.45], // 1# 8oz
            "water": ["pounds": 0, "ounces": 14.32], // 1#
            "yeast": ["pounds": 0, "ounces": 0.87], // 1oz
            "salt": ["pounds": 0, "ounces": 0.66], // 7/8oz
            "milk": ["pounds": 0, "ounces": 7.8], // 8oz
            "butter": ["pounds": 0, "ounces": 2.59], // 3 oz
            "sugar": ["pounds": 0, "ounces": 1.31] // 1.25 oz
        ]
        
        assertScaled(scaled: scaled, expected: expected)
    }
    
    func testCalculatePercentages_Lean() throws {
        let flours = [Ingredient(name: "flour", pounds: 1, ounces: 0)]
        let remaining = [
            Ingredient(name: "water", pounds: 0, ounces: 10),
            Ingredient(name: "salt", pounds: 0, ounces: 0.33),
            Ingredient(name: "yeast", pounds: 0, ounces: 0.5)
        ]
        let expected = ["flour": 1, "water": 0.625, "yeast": 0.031, "salt": 0.021]
        
        assertPercentages(flours: flours, remaining: remaining, expected: expected)
    }
    
    func testCalculatePercentages_Soft() throws {
        let flours = [Ingredient(name: "flour", pounds: 1, ounces: 12)]
        let remaining = [
            Ingredient(name: "water", pounds: 0, ounces: 11),
            Ingredient(name: "yeast", pounds: 0, ounces: 0.66),
            Ingredient(name: "milk", pounds: 0, ounces: 6),
            Ingredient(name: "butter", pounds: 0, ounces: 2),
            Ingredient(name: "sugar", pounds: 0, ounces: 1),
            Ingredient(name: "salt", pounds: 0, ounces: 0.5)
        ]
        let expected = ["flour": 1, "water": 0.393, "yeast": 0.024, "milk": 0.214, "butter": 0.071, "sugar": 0.036, "salt": 0.018]
        
        assertPercentages(flours: flours, remaining: remaining, expected: expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func assertPercentages(flours: [Ingredient], remaining: [Ingredient], expected: [String:Double]) {
        Ingredient.calculatePercentages(flours: flours, remaining: remaining)
        for ingredient in (flours + remaining) {
            let name = ingredient.getName()
            XCTAssertEqual(ingredient.getBakersPercentage(), expected[name]!, name)
        }
    }

    private func assertScaled(scaled: [IngredientStruct], expected: [String:[String:Double]]) {
        for (name, amounts) in expected {
            let ingredient = scaled.first(where: {$0.name == name})!
            
            XCTAssertEqual(ingredient.getPounds(), amounts["pounds"]!, "\(name) - pounds")
            XCTAssertEqual(ingredient.getOunces(), amounts["ounces"]!, "\(name) - ounces")
        }
    }
}
