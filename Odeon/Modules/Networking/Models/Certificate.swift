//
//  Certificate.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

enum Certificate: String, Codable {
    
    case toBeConfirmed = "TBC"
    case universal = "U"
    case parentalGuidance = "PG"
    case twelveA = "12A"
    case twelve = "12"
    case fifteen = "15"
    case eighteen = "18"
    case unknown
    
    // TODO: Map to unknown rather than crashing
    
}
