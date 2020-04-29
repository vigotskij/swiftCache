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
    }
    enum Keys: String {
        case store
        case remove
        case removeAll
    }
    var testingFuel: TestingFuel = .init()

    override func tearDown() {
        sut.clearVolatile()
        testingFuel = .init()
    }
    func testGetNil() {
        let result = sut.getValue(forKey: "") as? String
        XCTAssertEqual(result, nil)
    }
    func testGetStoredValue() {
        testingFuel.key = Keys.store.rawValue
        sut.setValue(testingFuel, forKey: testingFuel.key)
        let result = sut.getValue(forKey: testingFuel.key) as! TestingFuel
        XCTAssertEqual(result, testingFuel)
    }
    func testRemoveStoredValue() {
        testingFuel.key = Keys.remove.rawValue
        sut.setValue(testingFuel, forKey: testingFuel.key)
        let result = sut.getValue(forKey: testingFuel.key) as! TestingFuel
        XCTAssertEqual(result, testingFuel)
        sut.removeValue(forKey: testingFuel.key)
        let resultFromRemove = sut.getValue(forKey: testingFuel.key) as? TestingFuel
        XCTAssertEqual(resultFromRemove, nil)
    }
    func testRemoveAllStoredValues() {
        testingFuel.key = Keys.removeAll.rawValue
        sut.setValue(testingFuel, forKey: testingFuel.key)
        let firstCheck = sut.getValue(forKey: testingFuel.key) as? TestingFuel
        XCTAssertEqual(firstCheck, testingFuel)
        let result = sut.clearVolatile()
        XCTAssertTrue(result)
        let secondCheck = sut.getValue(forKey: testingFuel.key)
        XCTAssertNil(secondCheck)
    }
    func testGetKeysEmpty() {
        let result = sut.getKeys()
        XCTAssertTrue(result.count == 0)
    }
    func testRetrieveSomeKeys() {
        var stop = 0
        while stop < 10 {
            sut.setValue(TestingFuel(key: "\(stop)"), forKey: "\(stop)")
            stop += 1
        }
        let result = sut.getKeys()
        XCTAssertTrue(result.count == stop)
    }
    func testKeysOverflowing() {
        var stop = 0
        while stop < 100 {
            sut.setValue(TestingFuel(key: "\(stop)"), forKey: "\(stop)")
            stop += 1
        }
        let result = sut.getKeys()
        XCTAssertFalse(result.count > 50)
    }
}
