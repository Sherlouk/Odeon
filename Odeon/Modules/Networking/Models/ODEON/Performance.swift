//
//  Performance.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct Performance: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "performanceId"
        case time = "performanceTime"
        case attributes
        case status
    }
    
    let id: String
    let time: String
    let attributes: String
    let status: String // TODO: make this enum
    
}
