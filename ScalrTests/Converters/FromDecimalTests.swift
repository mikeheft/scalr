//
//  FromDecimalTests.swift
//  ScalrTests
//
//  Created by Michael Heft on 3/20/23.
//

import XCTest
@testable import Scalr

final class FromDecimalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConvert() throws {
        let converted = FromDecimal.convert(26, "")
        
        XCTAssertEqual(1, converted.getConvertedPounds())
        XCTAssertEqual(10, converted.getConvertedOunces())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
