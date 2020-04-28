//
//  Cache.swift
//
//  Created by Boris Sortino on 25/02/2020.
//  Copyright © 2020 Boris Sortin.
//
import Foundation

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
// MARK: - Wrapping classes for bridging between Obj-C NSCache and Swift elements
private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        // MARK: - This var and func are the bridge between NSCache and Swift Cache
        override var hash: Int { key.hashValue }
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return key == value.key
        }
    }

    final class CachedItem {
        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, with expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}
// MARK: - Cache + KeyTraker
private extension Cache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys: Set<Key> = .init()
        // MARK: - This function is called automaticaly just before erasing an element from cache
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            guard let value = obj as? CachedItem else {
                return
            }
            keys.remove(value.key)
        }
    }
}
// MARK: - VolatileCacheable implementation
extension Cache: VolatileCacheable {
    func setValue(_ value: Any?, forKey key: AnyHashable) {
        guard let value = value as? Value,
            let key = key as? Key else {
            return
        }
        let wrappedKey = WrappedKey(key)
        let expirationDate = dateProvider().addingTimeInterval(cacheLifetime)
        let wrappedValue = CachedItem(key: key, value: value, with: expirationDate)
        wrappedCache.setObject(wrappedValue, forKey: wrappedKey)
        keyTracker.keys.insert(wrappedKey.key)
    }

    func getValue(forKey key: AnyHashable) -> Any? {
        guard let key = key as? Key,
            let wrappedValue = wrappedCache.object(forKey: WrappedKey(key)) else {
                return nil
        }
        guard wrappedValue.expirationDate > dateProvider() else {
            removeValue(forKey: key)
            return nil
        }
        return wrappedValue.value
    }

    func removeValue(forKey key: AnyHashable) {
        guard let key = key as? Key else {
            return
        }
        wrappedCache.removeObject(forKey: WrappedKey(key))
    }

    func getKeys() -> Set<AnyHashable> {
        return keyTracker.keys as Set<Key>
    }

    subscript(key: AnyHashable) -> Any? {
        get {
            return getValue(forKey: key)
        }
        set {
            guard let value = newValue else {
                self.removeValue(forKey: key)
                return
            }
            setValue(value, forKey: key)
        }
    }
}
// MARK: - Cache + Codable
extension Cache.CachedItem: Codable where Key: Codable, Value: Codable {}
extension Cache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.singleValueContainer()
        let entries = try container.decode([CachedItem].self)
        entries.forEach(setItem)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(getItem))
    }
}
// MARK: - Cache functions to populate from and to persistent data
private extension Cache {
    func setItem(_ value: CachedItem) {
        if value.expirationDate > dateProvider() {
            wrappedCache.setObject(value, forKey: WrappedKey(value.key))
            keyTracker.keys.insert(value.key)
        }
    }
    func getItem(forKey key: Key) -> CachedItem? {
        guard let item = wrappedCache.object(forKey: WrappedKey(key)) else {
            return nil
        }
        guard item.expirationDate > dateProvider() else {
            removeValue(forKey: key)
            return nil
        }
        return item
    }
}
// MARK: - Cache + PersistentCacheable
extension Cache: PersistentCacheable where Key: Codable, Value: Codable {
    func persist(withName name: String, using fileManager: FileManager = .default, completionHandler: (Result<Bool, Error>) -> Void) throws {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        do {
            let data = try JSONEncoder().encode(self)
            try data.write(to: fileURL)
        } catch {
            completionHandler(.failure(error))
        }
    }
    func load(withName name: String, using fileManager: FileManager, completionHandler: (Result<Bool, Error>) -> Void) throws {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        do {
            let data = try Data(contentsOf: fileURL)
            let parsedData = try JSONDecoder().decode([CachedItem].self, from: data)
            parsedData.forEach(setItem)
        } catch {
            completionHandler(.failure(error))
        }
    }
}
