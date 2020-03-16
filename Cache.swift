//
//  Cache.swift
//
//  Created by Boris Sortino on 25/02/2020.
//  Copyright © 2020 Boris Sortin.
//

final class Cache<Key: Hashable, Value> {
    private let wrappedCache = NSCache<WrappedKey, CachedItem>()
    private let dateProvider: () -> Date
    private let cacheLifetime: TimeInterval
    private let keyTracker: KeyTracker = .init()

    /// Default Initializer
    /// - Parameters:
    ///   - dateProvider: Closure for date provider injection. Default: Date.init
    ///   - cacheLifetime: Time in seconds. Default lifetime: 12 hours.
    ///   - maximCachedValues: Amount of elements to be stored. 0 == unlimited
    init(dateProvider: @escaping () -> Date = Date.init,
         cacheLifetime: TimeInterval = 43200,
         maximumCachedValues: Int = 50) {
        self.dateProvider = dateProvider
        self.cacheLifetime = cacheLifetime
        wrappedCache.countLimit = maximumCachedValues
        wrappedCache.delegate = keyTracker
    }
}
