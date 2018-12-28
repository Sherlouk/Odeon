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
    
    let payload: CastDetails
    var cachedStructure: [ItemTypeTuple]?
    
    var stretchyHeaderViewModel: ProfileStretchyHeaderViewModel?
    var callToActionViewModel: ProfileCallToActionViewModel?
    var actionHandler: ProfileActionHandler?
    var sharableItems: [String]?
    
    init(payload: CastDetails) {
        self.payload = payload
        setStretchyHeader()
    }
    
    func setStretchyHeader() {
        
        stretchyHeaderViewModel = ProfileStretchyHeaderViewModel(
            title: payload.name,
            description: nil,
            imageURL: payload.profile_path?.makeURL(),
            tags: [ payload.known_for_department ]
        )
        
    }
    
    var structure: [ItemTypeTuple] {
        
        if let cached = cachedStructure {
            return cached
        }
        
        let initialCast = payload.movie_credits.cast.prefix(10)
        let castViewModels = Array(initialCast).map({ castMember -> ScrollerImageViewModel in
            ScrollerImageViewModel(
                title: castMember.title,
                imageURL: castMember.poster_path.makeURL(),
                aspectRatio: .poster,
                tapAction: nil
            )
        })
        
        let structure: [ItemTypeTuple] = [
            (.title, ProfileTitleViewModel(title: "Filmography", buttonText: "SEE ALL", buttonAction: {
                print("SEE ALL FILMOGRAPHY")
            })),
            (.scroller, HorizontalScrollerViewModel(itemSize: CGSize(width: 140, height: 260), contents: castViewModels)),
            (.paragraph, ProfileTextViewModel(title: "Biography", text: payload.biography)),
            (.title, ProfileTitleViewModel(title: "On The Web", buttonText: nil, buttonAction: nil)),
            (.social, nil),
            (.copyright, nil),
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
