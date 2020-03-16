//
//  PersitentCacheable.swift
//
//  Created by Boris Sortino on 25/02/2020.
//  Copyright © 2020 Boris Sortino.
//

protocol PersistentCacheable {
    func persist(withName name: String, using fileManager: FileManager) throws
    func load(withName name: String, using fileManager: FileManager) throws
}
