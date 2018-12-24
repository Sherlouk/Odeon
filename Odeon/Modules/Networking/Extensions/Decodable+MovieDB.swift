//
//  Decodable+MovieDB.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct MDBImageURL: Codable {
    
    enum Size: String {
        // https://developers.themoviedb.org/3/configuration/get-api-configuration
        case original
    }
    
    let path: String?
    
    // MARK: - Codable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        path = try? container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(path)
    }
    
    // MARK: - Convenience
    
    func makeURL(size: Size = .original) -> URL? {
        guard let path = path else {
            return nil
        }
        
        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)/\(path)")
    }
    
}
