//
//  Array+CompactCast.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

extension Array {
    
    func compactCast<T>(target: T.Type) -> [T] {
        return compactMap({ $0 as? T })
    }
    
}
