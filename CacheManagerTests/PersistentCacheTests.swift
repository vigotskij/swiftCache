//
//  PersistentCacheTests.swift
//  CacheManagerTests
//
//  Created by Boris Sortino on 24/04/2020.
//  Copyright © 2020 Boris Sortino. All rights reserved.
//

import XCTest
@testable import CacheManager

class PersistentCacheTests: XCTestCase {
    let sut: PersistentCacheable = Cache<String, TestingFuel>()
    var testingFuel: TestingFuel = .init()
    
    struct TestingFuel: Codable {
        var key = ""
        var value = "Test Value"
    }
    enum CacheFileNames: String {
        case persistence
        case loading
    }
    override func tearDown() {
        _ = sut.load(withName: CacheFileNames.loading.rawValue, using: .default)
        _ = sut.load(withName: CacheFileNames.persistence.rawValue, using: .default)
        let keys = sut.getKeys()
        for key in keys {
            sut.removeValue(forKey: key)
        }
        testingFuel = .init()
    }
    func testPersistence() {
        testingFuel.key = "persistence"
        sut.setValue(testingFuel, forKey: testingFuel.key)
        let result = sut.persist(withName: CacheFileNames.persistence.rawValue, using: .default)
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    func testLoadFromPersistance() {
        testingFuel.key = "loading"
        sut.setValue(testingFuel, forKey: testingFuel.key)
        sut.persist(withName: CacheFileNames.loading.rawValue, using: .default)
        sut.removeValue(forKey: "loading")
        let result = sut.load(withName: CacheFileNames.loading.rawValue, using: .default)
        switch result {
        case .success(let success):
            XCTAssertTrue(success)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
