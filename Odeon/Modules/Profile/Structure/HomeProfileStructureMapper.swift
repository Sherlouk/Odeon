//
//  HomeProfileStructureMapper.swift
//  Odeon
//
//  Created by Sherlock, James on 27/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

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
            ScrollerImageViewModel(
                title: $0.title,
                imageURL: $0.posterImageURL,
                aspectRatio: .poster,
                tapAction: .openFilmDetails(film: $0)
            )
        })
        
        let filmToViewModelMapping: (OdeonFilm) -> ScrollerImageViewModel = { film -> ScrollerImageViewModel in
            ScrollerImageViewModel(
                title: film.title,
                imageURL: film.posterImageUrl,
                aspectRatio: .poster,
                tapAction: .openFilmDetails(film: film)
            )
        }
        
        let topFilms = payload.topFilms.map(filmToViewModelMapping)
        let newFilms = payload.newFilms.map(filmToViewModelMapping)
        let recommendedFilms = payload.recommendedFilms.map(filmToViewModelMapping)
        let comingSoonFilms = payload.comingSoonFilms.map(filmToViewModelMapping)
        
        var smallItemSize = CGSize(height: 260, aspectRatio: .poster)
        smallItemSize.height += 60
        
        let width = UIScreen.main.bounds.width * 0.6
        var largeItemSize = CGSize(width: width, aspectRatio: .poster)
        largeItemSize.height += 60
        
        let structure: [ItemTypeTuple] = [
            (.title, ProfileTitleViewModel(title: "Movies On Today", buttonText: nil, buttonAction: nil)),
            (.scroller, HorizontalScrollerViewModel(itemSize: largeItemSize, contents: moviesOnToday)),
            (.title, ProfileTitleViewModel(title: "Top Films", buttonText: nil, buttonAction: nil)),
            (.scroller, HorizontalScrollerViewModel(itemSize: smallItemSize, contents: topFilms)),
            (.title, ProfileTitleViewModel(title: "New Films", buttonText: nil, buttonAction: nil)),
            (.scroller, HorizontalScrollerViewModel(itemSize: smallItemSize, contents: newFilms)),
            (.title, ProfileTitleViewModel(title: "Recommended Films", buttonText: nil, buttonAction: nil)),
            (.scroller, HorizontalScrollerViewModel(itemSize: smallItemSize, contents: recommendedFilms)),
            (.title, ProfileTitleViewModel(title: "Coming Soon", buttonText: nil, buttonAction: nil)),
            (.scroller, HorizontalScrollerViewModel(itemSize: smallItemSize, contents: comingSoonFilms)),
            (.copyright, nil),
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
