//
//  PersitentCacheable.swift
//
//  Created by Boris Sortino on 25/02/2020.
//  Copyright © 2020 Boris Sortino.
//

protocol PersistentCacheable: VolatileCacheable {
    @discardableResult func persist(withName name: String, using fileManager: FileManager) -> Result<Bool, Error>
    func load(withName name: String, using fileManager: FileManager) -> Result<Bool, Error>
}
