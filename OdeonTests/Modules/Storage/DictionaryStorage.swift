//
//  DictionaryStorage.swift
//  OdeonTests
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
@testable import Odeon

class DictionaryStorage: Storage {
    
    var storage: [String: Any]
    
    init(initialStorage: [String: Any] = [:]) {
        self.storage = initialStorage
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func set(_ value: Int, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
    }
    
    func string(forKey defaultName: String) -> String? {
        return storage[defaultName] as? String
    }
    
    func integer(forKey defaultName: String) -> Int {
        // UserDefaults will return zero if the value can not be found or formed
        return (storage[defaultName] as? Int) ?? 0
    }
    
    func bool(forKey defaultName: String) -> Bool {
        // UserDefaults will return false if the value can not be found or formed
        return (storage[defaultName] as? Bool) ?? false
    }
    
}
