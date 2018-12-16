//
//  ListFilmsResponse.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct ListFilmsResponse: Codable {
    
    struct Data: Codable {
        let films: [Film]
    }
    
    let data: Data
    
}
