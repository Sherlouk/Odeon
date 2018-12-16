//
//  ListCinemasResponse.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct ListCinemasResponse: Codable {
    
    struct Data: Codable {
        let sites: [String: Cinema]
    }
    
    let data: Data
    
    var cinema: [Cinema] {
        return Array(data.sites.values)
    }
    
}
