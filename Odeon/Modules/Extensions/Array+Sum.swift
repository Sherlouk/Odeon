//
//  Array+Sum.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

extension Array where Element: Numeric {
    
    func sum() -> Element {
        return reduce(0, +)
    }
    
}
