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
            tags: [ film.genre ].compactMap({ $0 })
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
                tapAction: .openFilmDetails(film: $0),
                secondaryText: nil,
                halfRating: $0.rating,
                certificate: $0.certificate
            )
        })
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        
        let filmToViewModelMapping: (OdeonFilm) -> ScrollerImageViewModel = { film -> ScrollerImageViewModel in
            var description: String?
            
            if film.releaseDate.date > now {
                description = "OUT " + dateFormatter.string(from: film.releaseDate.date).uppercased()
            }
            
            return ScrollerImageViewModel(
                title: film.title,
                imageURL: film.posterImageUrl,
                aspectRatio: .poster,
                tapAction: .openFilmDetails(film: film),
                secondaryText: description,
                halfRating: film.rating,
                certificate: film.certificate
            )
        }
        
        let topFilms = payload.topFilms.map(filmToViewModelMapping)
        let newFilms = payload.newFilms.map(filmToViewModelMapping)
        let recommendedFilms = payload.recommendedFilms.map(filmToViewModelMapping)
        
        // Sort coming soon films by their release date
        let comingSoonFilms = payload.comingSoonFilms.sorted(by: { (lhs, rhs) -> Bool in
            lhs.releaseDate.date < rhs.releaseDate.date
        }).map(filmToViewModelMapping)
        
        let smallItemWidth = UIScreen.main.bounds.width * 0.4
        var smallItemSize = CGSize(width: smallItemWidth, aspectRatio: .poster)
        smallItemSize.height += 115
        
        var smallItemWithDescription = smallItemSize
        smallItemWithDescription.height += 35
        
        let largeItemWidth = UIScreen.main.bounds.width * 0.6
        var largeItemSize = CGSize(width: largeItemWidth, aspectRatio: .poster)
        largeItemSize.height += 90
        
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
            (.scroller, HorizontalScrollerViewModel(itemSize: smallItemWithDescription, contents: comingSoonFilms)),
            (.copyright, nil),
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
