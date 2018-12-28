//
//  Film.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct OdeonFilm: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "filmMasterId"
        case title
        case rating = "halfRating"
        case posterImageUrl = "posterUrl"
        case imageUrl
        case certificate
        case releaseDate
        case genre
        case trailerUrl
        case attributes
        case offers
    }
    
    let id: Int
    let title: String
    let rating: Int
    let posterImageUrl: URL
    let imageUrl: URL
    let certificate: Certificate
    let releaseDate: DateWrapper<YearMonthDay>
    let genre: String?
    let trailerUrl: URL?
    let attributes: String?
    let offers: [Offer]
    
    func convertAttributes(using odeonAttributes: [FilmAttributesResponse.Attributes]) -> [FilmAttributesResponse.Attributes] {
        guard let attributes = attributes?.components(separatedBy: ",") else {
            return []
        }
        
        return odeonAttributes.filter { attribute -> Bool in
            attributes.contains(String(attribute.id))
        }
    }
    
}
