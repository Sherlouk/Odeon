//
//  Decodable+EmptyString.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct EmptyString: Codable {
    
    enum Error: Swift.Error {
        case emptyString
    }
    
    let value: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        var rawValue = try container.decode(String.self)
        rawValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if rawValue.isEmpty {
            value = nil
        } else {
            value = rawValue
        }
    }
    
}
