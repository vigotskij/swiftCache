//
//  VolatileCacheTests.swift
//  CacheManagerTests
//
//  Created by Boris Sortino on 22/04/2020.
//  Copyright © 2020 Boris Sortino. All rights reserved.
//

import XCTest
@testable import CacheManager

class VolatileCacheTests: XCTestCase {
    
    let sut: VolatileCacheable = Cache<String, TestingFuel>()
    
    struct TestingFuel: Equatable {
        var key: String = ""
        var value: String = ""
    }
    var testingFuel: TestingFuel = .init()

    override func tearDown() {
        let keys = sut.getKeys()
        for key in keys {
            sut.removeValue(forKey: key)
        }
        testingFuel = .init()
    }
    func testGetNil() {
        let result = sut.getValue(forKey: "") as? String
        XCTAssertEqual(result, nil)
    }
    func testGetStoredValue() {
        testingFuel.key = "1"
        testingFuel.value = "value to retrieve"
        sut.setValue(testingFuel, forKey: testingFuel.key)
        let result = sut.getValue(forKey: testingFuel.key) as! TestingFuel
        XCTAssertEqual(result, testingFuel)
    }
    func testRemoveStoredValue() {
        testingFuel.key = "2"
        testingFuel.value = "value to remove"
        sut.setValue(testingFuel, forKey: testingFuel.key)
        let result = sut.getValue(forKey: testingFuel.key) as! TestingFuel
        XCTAssertEqual(result, testingFuel)
        sut.removeValue(forKey: testingFuel.key)
        let resultFromRemove = sut.getValue(forKey: testingFuel.key) as? TestingFuel
        XCTAssertEqual(resultFromRemove, nil)
    }
    func testGetKeysEmpty() {
        let result = sut.getKeys()
        XCTAssertTrue(result.count == 0)
    }
    func testRetrieveSomeKeys() {
        var stop = 0
        while stop < 10 {
            sut.setValue(TestingFuel(key: "\(stop)", value: "\(stop)"), forKey: "\(stop)")
            stop += 1
        }
        let result = sut.getKeys()
        XCTAssertTrue(result.count == stop)
    }
    func testKeysOverflowing() {
        var stop = 0
        while stop < 100 {
            sut.setValue(TestingFuel(key: "\(stop)", value: "\(stop)"), forKey: "\(stop)")
            stop += 1
        }
        let result = sut.getKeys()
        XCTAssertFalse(result.count > 50)
    }
}
