//
//  ProfileStructureMapper.swift
//  Odeon
//
//  Created by Sherlock, James on 23/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

protocol ProfileStructureMapper {
    
    var stretchyHeaderViewModel: ProfileStretchyHeaderViewModel? { get }
    var structure: [(itemType: ProfileItemType, object: Any?)] { get }
    
}
