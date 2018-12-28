//
//  FilmDetails.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct FilmDetails: Codable {
    
    // ODEON
    
    let plot: String
    let customerAdvice: String?
    let director: String?
    let casts: String?
    let runningTime: String?
    let language: String
    let country: String
    let certificate: Certificate
    let releaseDate: String
    let sites: [Int]
    
}
