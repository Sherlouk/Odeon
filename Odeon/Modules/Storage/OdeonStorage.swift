//
//  OdeonStorage.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

class OdeonStorage {
    
    // MARK: - Variables
    
    let storage: Storage
    
    // MARK: - Initialiser
    
    init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }
    
    // MARK: - Setters & Getters
    
    var userChosenCountry: String? {
        get { return storage.string(forKey: #function) }
        set { storage.set(newValue, forKey: #function) }
    }
    
    var userChosenCinema: Int? {
        get {
            if storage.object(forKey: #function) != nil {
                return storage.integer(forKey: #function)
            }
            
            return nil
        }
        set { storage.set(newValue, forKey: #function) }
    }
    
}
