//
//  VolatileCachePerformanceTests.swift
//  CacheManagerTests
//
//  Created by Boris Sortino on 23/04/2020.
//  Copyright © 2020 Boris Sortino. All rights reserved.
//

import XCTest
@testable import CacheManager

class VolatileCachePerformanceTests: XCTestCase {
    var sut: VolatileCacheable = Cache<String, TestingFuel>(maximumCachedValues: 1000000)

    struct TestingFuel: Equatable {
        var key: String = ""
        var value: String = ""
    }

    var testingFuelArray: [TestingFuel] = []
    
    override func setUp() {
        var stop = 0
        while stop < 100000 {
            testingFuelArray.append(TestingFuel(key: "\(stop)", value: "\(stop)"))
            stop += 1
        }
    }
    override func tearDown() {
        testingFuelArray = []
        clearVolatileCache()
    }
    private func populateCache() {
        for item in testingFuelArray {
            sut.setValue(item, forKey: item.key)
        }
    }
    func testSetPerformance() {
        measure {
            populateCache()
        }
    }
    func testGetKeysPerformance() {
        populateCache()
        measure {
            _ = sut.getKeys()
        }
    }
    func testGetPerformance() {
        populateCache()
        measure {
            for item in testingFuelArray {
                _ = sut.getValue(forKey: item.key)
            }
        }
    }
    func testRemovePerformance() {
        measure {
            populateCache()
            clearVolatileCache()
        }
    }
    func clearVolatileCache() {
        let keys = sut.getKeys()
        for key in keys {
            sut.removeValue(forKey: key)
        }
    }
}
