//
//  Offer.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct Offer: Codable {
    
    struct Images: Codable {
        
        enum CodingKeys: String, CodingKey {
            case thumbnail = "140x140"
            case medium = "300x170"
            case large = "460x260"
        }
        
        let thumbnail: String
        let medium: String
        let large: String
        
    }
    
    enum OfferType: String, Codable {
        case offer
        case competition
    }
    
    let id: Int
    let title: String
    let teaser: String
    let text: String
    let terms: String
    let validFrom: String // TODO: Make this date (2018-12-12 00:30:00)
    let validTo: String // TODO: Make this date (2018-12-12 00:30:00)
    let type: OfferType
    let images: Images
    
}
