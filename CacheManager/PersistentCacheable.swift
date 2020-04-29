//
//  PersitentCacheable.swift
//
//  Created by Boris Sortino on 25/02/2020.
//  Copyright © 2020 Boris Sortino.
//

protocol PersistentCacheable: VolatileCacheable {
    /// This function will store the data from the Volatile Cache.
    /// Function's result will be `.success(true)` if the process was successful and `.failure(Error)` in any failure scenario
    /// - Parameters:
    ///   - name: Name for the destination file without extension
    ///   - fileManager: This will manage the storing process
    @discardableResult func persist(withName name: String, using fileManager: FileManager) -> Result<Bool, Error>
    /// This function will try to load all the persisted data to the Volatile Cache
    /// Function's result will be `.success(true)` if the process was successful and `.failure(Error)` in any failure scenario
    /// - Parameters:
    ///   - name: Origin file name without extension
    ///   - fileManager: This will manage the retrieving process
    func load(withName name: String, using fileManager: FileManager) -> Result<Bool, Error>
    /// This function will search and try to remove the specified file
    /// Function's result will be `.success(true)` if the process was successful and `.failure(Error)` in any failure scenario
    /// - Parameters:
    ///   - name: File name to be removed, without extension
    ///   - fileManager: This will manage the removing process
    @discardableResult func clearPersistence(withName name: String, using fileManager: FileManager) -> Result<Bool, Error>
}
