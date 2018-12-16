//
//  PerformanceAttributesResponse.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct PerformanceAttributesResponse: Codable {
    
    struct Attributes: Codable {
        let id: Int
        let name: String
    }
    
    let data: [Attributes]
    
}
