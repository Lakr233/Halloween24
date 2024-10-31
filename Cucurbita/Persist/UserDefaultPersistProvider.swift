//
//  UserDefaultPersistProvider.swift
//  MobileAffine
//
//  Created by 秋星桥 on 2024/6/28.
//

import Foundation

class UserDefaultPersistProvider: PersistProvider {
    func data(forKey: String) -> Data? {
        UserDefaults.standard.data(forKey: forKey)
    }

    func set(_ data: Data?, forKey: String) {
        UserDefaults.standard.set(data, forKey: forKey)
    }
}

extension Persist {
    init(key: String, defaultValue: Value) {
        self.init(key: key, defaultValue: defaultValue, engine: UserDefaultPersistProvider())
    }
}

extension PublishedPersist {
    init(key: String, defaultValue: Value) {
        self.init(key: key, defaultValue: defaultValue, engine: UserDefaultPersistProvider())
    }
}
