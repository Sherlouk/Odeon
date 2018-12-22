//
//  Cinema.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import CoreLocation

struct Cinema: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "siteId"
        case name = "siteName"
        case addressLineOne = "siteAddress1"
        case addressLineTwo = "siteAddress2"
        case addressLineThree = "siteAddress3"
        case addressLineFour = "siteAddress4"
        case postcode = "sitePostcode"
        case telephoneNumber = "siteTelephone"
        case longitude = "siteLongitude"
        case latitude = "siteLatitude"
        case isLuxe = "siteIsLuxe"
    }
    
    let id: String
    let name: String
    let addressLineOne: String
    let addressLineTwo: String
    let addressLineThree: String?
    let addressLineFour: String?
    let postcode: String
    let telephoneNumber: String
    let longitude: String
    let latitude: String
    let isLuxe: Bool
    
    var coordinates: CLLocation? {
        guard let latitude = CLLocationDegrees(latitude) else { return nil }
        guard let longitude = CLLocationDegrees(longitude) else { return nil }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}
