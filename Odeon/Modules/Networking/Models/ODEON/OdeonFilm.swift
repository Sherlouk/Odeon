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
        case isRateable
        case attributes
        case offers
    }
    
    let id: Int
    let title: String
    let rating: Int
    let posterImageUrl: URL
    let imageUrl: URL
    let certificate: Certificate
    let releaseDate: String // TODO: Make this date (20181214)
    let genre: String?
    let trailerUrl: URL?
    let isRateable: Int // TODO: Turn this into bool (0/1)
    let attributes: String?
    let offers: [Offer]
    
    func convertAttributes(using response: FilmAttributesResponse) -> [FilmAttributesResponse.Attributes] {
        guard let attributes = attributes?.components(separatedBy: ",") else {
            return []
        }
        
        return attributes.compactMap({ attribute -> FilmAttributesResponse.Attributes? in
            return response.data.first(where: { $0.id == Int(attribute) })
        })
    }
    
}
