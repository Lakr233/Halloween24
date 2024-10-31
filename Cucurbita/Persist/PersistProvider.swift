//
//  PersistProvider.swift
//  MobileAffine
//
//  Created by 秋星桥 on 2024/6/28.
//

import Foundation

protocol PersistProvider {
    func data(forKey: String) -> Data?
    func set(_ data: Data?, forKey: String)
}
