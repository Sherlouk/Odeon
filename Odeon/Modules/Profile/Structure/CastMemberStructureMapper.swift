//
//  CastMemberStructureMapper.swift
//  Odeon
//
//  Created by Sherlock, James on 28/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class CastMemberStructureMapper: ProfileStructureMapper {
    
    typealias ItemTypeTuple = (itemType: ProfileItemType, object: Any?)
    
    let payload: HomeFetcher.Payload
    var cachedStructure: [ItemTypeTuple]?
    
    var stretchyHeaderViewModel: ProfileStretchyHeaderViewModel?
    var callToActionViewModel: ProfileCallToActionViewModel?
    var actionHandler: ProfileActionHandler?
    var sharableItems: [String]?
    
    init(payload: HomeFetcher.Payload) {
        self.payload = payload
        setStretchyHeader()
    }
    
    func setStretchyHeader() {
        
        guard let film = payload.cinemaFilms.first else {
            return
        }
        
        stretchyHeaderViewModel = ProfileStretchyHeaderViewModel(
            title: film.title,
            description: nil,
            imageURL: film.imageURL,
            tags: [ film.genre ]
        )
        
    }
    
    var structure: [ItemTypeTuple] {
        
        if let cached = cachedStructure {
            return cached
        }
        
        let structure: [ItemTypeTuple] = [
            (.title, ProfileTitleViewModel(title: "Coming Soon...", buttonText: nil, buttonAction: nil)),
            (.copyright, nil),
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
