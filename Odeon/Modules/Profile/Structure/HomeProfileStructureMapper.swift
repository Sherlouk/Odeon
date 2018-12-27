//
//  HomeProfileStructureMapper.swift
//  Odeon
//
//  Created by Sherlock, James on 27/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

class HomeProfileStructureMapper: ProfileStructureMapper {
    
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
        
        let moviesOnToday = Array(payload.cinemaFilms.dropFirst()).map({
            ScrollerImageViewModel(title: $0.title, imageURL: $0.posterImageURL)
        })
        
        let topFilms = payload.topFilms.map({
            ScrollerImageViewModel(title: $0.title, imageURL: $0.posterImageUrl)
        })
        
        let newFilms = payload.newFilms.map({
            ScrollerImageViewModel(title: $0.title, imageURL: $0.posterImageUrl)
        })
        
        let recommendedFilms = payload.recommendedFilms.map({
            ScrollerImageViewModel(title: $0.title, imageURL: $0.posterImageUrl)
        })
        
        let comingSoonFilms = payload.comingSoonFilms.map({
            ScrollerImageViewModel(title: $0.title, imageURL: $0.posterImageUrl)
        })
        
        let structure: [ItemTypeTuple] = [
            (.title, ProfileTitleViewModel(title: "Movies On Today", buttonText: nil, buttonAction: nil)),
            (.scroller, moviesOnToday),
            (.title, ProfileTitleViewModel(title: "Top Films", buttonText: nil, buttonAction: nil)),
            (.scroller, topFilms),
            (.title, ProfileTitleViewModel(title: "New Films", buttonText: nil, buttonAction: nil)),
            (.scroller, newFilms),
            (.title, ProfileTitleViewModel(title: "Recommended Films", buttonText: nil, buttonAction: nil)),
            (.scroller, recommendedFilms),
            (.title, ProfileTitleViewModel(title: "Coming Soon", buttonText: nil, buttonAction: nil)),
            (.scroller, comingSoonFilms),
            (.copyright, nil),
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
