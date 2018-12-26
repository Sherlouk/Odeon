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
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    struct Address: Codable {
        let line1: String
        let line2: EmptyString
        let line3: EmptyString
        let line4: EmptyString
        let postcode: String
    }
    
    struct Information: Codable {
        let contact: EmptyString
        let generalManager: EmptyString
        let location: EmptyString
        let publicTransport: EmptyString
        let drivingDirections: EmptyString
        let localFacilities: EmptyString
        let cinemaInfo: EmptyString
        let tickets: EmptyString
        let auditoriumInfo: EmptyString
        let gallery: EmptyString
        let education: EmptyString
        let disabledFacilities: EmptyString
        let conference: EmptyString
        let auditoriumFooter: EmptyString
        let bookingFee: EmptyString
        let keywords: EmptyString
    }
    
    let id: Int
    let name: String
    let isLuxe: Bool
    let location: Location
    let telephone: String
    let address: Address
    let bookingMessages: [String]
    let information: Information
    let otherLocalCinemas: String
    
}
