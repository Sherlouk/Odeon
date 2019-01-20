//
//  OdeonFilmInCinema.swift
//  Odeon
//
//  Created by Sherlock, James on 27/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct OdeonFilmInCinema: Codable {
    
    struct Film: Codable {
        enum CodingKeys: String, CodingKey {
            case id = "filmMasterId"
            case title, certificate, genre
            case rating = "halfRating"
            case posterImageURL = "poster220x320Url"
            case imageURL = "imageUrl"
            case attributes
        }
        
        let id: Int
        let title: String
        let certificate: Certificate
        let genre: String?
        let rating: Int
        let posterImageURL: URL
        let imageURL: URL
        let attributes: String
    }
    
    let film: Film
    
}
