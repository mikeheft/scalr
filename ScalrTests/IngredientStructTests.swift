//
//  IngredientStructTests.swift
//  ScalrTests
//
//  Created by Michael Heft on 2/7/23.
//

import XCTest
@testable import Scalr

final class IngredientStructTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFormattedOunces() {
        let water = IngredientStruct(name: "Water", pounds: 0, ounces: 10.0, bakersPercentage: 0.625)
        let salt = IngredientStruct(name: "Salt", pounds: 0, ounces: 0.02, bakersPercentage: 0.022)
        let flour = IngredientStruct(name: "Flour", pounds: 1, ounces: 0.0, bakersPercentage: 1.0)
        
        XCTAssertEqual(water.formattedOunces(), "10 oz")
//        XCTAssertEqual(salt.formattedOunces(), "0.02 oz")
//        XCTAssertEqual(flour.formattedOunces(), "")
    }

    func testScale() {
        let desiredPortions = ["noPortions":4.0, "poundsPerPortion": 0.0, "ouncesPerPortion":14.5]
        let flour = Ingredient(name: "Flour", pounds: 1, ounces: 0.0, bakersPercentage: 1.0)
        let water = Ingredient(name: "Water", pounds: 0, ounces: 10.0, bakersPercentage: 0.625)
        let yeast = Ingredient(name: "Yeast", pounds: 0, ounces: 0.03, bakersPercentage: 0.033)
        let salt = Ingredient(name: "Salt", pounds: 0, ounces: 0.02, bakersPercentage: 0.022)
        let actual = IngredientStruct.scale(desiredPortionAmounts: desiredPortions, flours: [flour], remaining: [water, salt, yeast])
        let actualTotal = round(actual.reduce(0.0) { $0 + (Double($1.pounds) + $1.ounces)} * 1000) / 1000
        let expectedTotal = desiredPortions["noPortions"]! * (desiredPortions["poundsPerPortion"]! + (desiredPortions["ouncesPerPortion"]! / 16.0))
        
        XCTAssertEqual(actualTotal, expectedTotal, "\(actual) != \(expectedTotal)")
    }
    
    private func assertFailMsg(_ actual: Any, _ expected: Any) -> String {
        return String("Expected \(expected) got \(actual) instead.")
    }

}
