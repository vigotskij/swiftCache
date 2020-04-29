//
//  PersistentCachePerformanceTests.swift
//  CacheManagerTests
//
//  Created by Boris Sortino on 28/04/2020.
//  Copyright © 2020 Boris Sortino. All rights reserved.
//

import XCTest
@testable import CacheManager

class PersistentCachePerformanceTests: XCTestCase {
    let sut: PersistentCacheable = Cache<String, TestingFuel>(maximumCachedValues: 100000)
    
    struct TestingFuel: Codable {
        var key = ""
    }
    enum PersistenceNames: String {
        case persist
        case load
        case remove
    }
    override func setUp() {
        populateVolatileCache()
    }
    override func tearDown() {
        clearPersistentCache()
        clearVolatileCache()
    }
    func testPersistPerformance() {
        measure {
            sut.persist(withName: PersistenceNames.persist.rawValue, using: .default)
        }
    }
    func testLoadPerformance() {
        sut.persist(withName: PersistenceNames.load.rawValue, using: .default)
        measure {
            _ = sut.load(withName: PersistenceNames.load.rawValue, using: .default)
        }
    }
    func testRemovePersistedData() {
        measure {
            sut.persist(withName: PersistenceNames.remove.rawValue, using: .default)
            sut.clearPersistence(withName: PersistenceNames.remove.rawValue, using: .default)
        }
    }
}
// MARK: - Helper functions
private extension PersistentCachePerformanceTests {
    func populateVolatileCache() {
        var stop = 0
        while stop < 100000 {
            sut.setValue(TestingFuel(key: "\(stop)"), forKey: "\(stop)")
            stop += 1
        }
    }
    func clearVolatileCache() {
        for key in sut.getKeys() {
            sut.removeValue(forKey: key)
        }
    }
    func clearPersistentCache() {
        _ = sut.clearPersistence(withName: PersistenceNames.persist.rawValue, using: .default)
        _ = sut.clearPersistence(withName: PersistenceNames.load.rawValue, using: .default)
        _ = sut.clearPersistence(withName: PersistenceNames.remove.rawValue, using: .default)
    }
}
