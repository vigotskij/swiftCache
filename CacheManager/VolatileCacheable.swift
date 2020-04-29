//
//  VolatileCacheable.swift
//
//  Created by Boris Sortino on 25/02/2020.
//  Copyright © 2020 Boris Sortino.
//

protocol VolatileCacheable {
    /// Sets the pair value and key to be stored in a Cache object
    /// - Parameters:
    ///   - value: Value to be stored
    ///   - key: Hashable Key for Value reference
    func setValue(_ value: Any?, forKey key: AnyHashable)
    /// Returns a stored value or nil
    /// - Parameter key: Hashable Key for Value reference
    func getValue(forKey key: AnyHashable) -> Any?
    /// Remove value if exists for reference Key
    /// - Parameter key: Hashable Key for Value reference
    func removeValue(forKey key: AnyHashable)
    /// Clear everything from Volatile Cache
    @discardableResult func clearVolatile() -> Bool
    /// Obtain the set containing all the stored keys
    func getKeys() -> Set<AnyHashable>
    /// subscript allows us to use the
    /// CacheObject[HashableKey] = Value? get-setting
    subscript(key: AnyHashable) -> Any? { get set }
}
