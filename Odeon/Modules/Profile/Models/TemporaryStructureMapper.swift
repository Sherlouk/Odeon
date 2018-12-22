//
//  TemporaryStructureMapper.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

class TemporaryStructureMapper {
    
    typealias ItemTypeTuple = (itemType: ProfileItemType, object: Any?)
    
    let film: FilmFetcher.Film
    var cachedStructure: [ItemTypeTuple]?
    
    init(film: FilmFetcher.Film) {
        self.film = film
    }
    
    var struture: [ItemTypeTuple] {
        
        if let cached = cachedStructure {
            return cached
        }
        
        let reviewOne = ProfileReviewViewModel(
            revieweeName: "James Sherlock",
            reviewwImageURL: URL(string: "https://google.com/")!,
            reviewDate: Date(),
            halfRating: 5,
            reviewDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In pulvinar elit ante, sed commodo purus rutrum vitae. Aliquam vel tellus tincidunt, mattis magna consectetur, efficitur ante. Sed neque eros, volutpat eu luctus in, ultricies in lectus."
        )

        let reviewTwo = ProfileReviewViewModel(
            revieweeName: "John Smith",
            reviewwImageURL: URL(string: "https://google.com/")!,
            reviewDate: Date(),
            halfRating: 6,
            reviewDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In pulvinar elit ante, sed commodo purus rutrum vitae. Aliquam vel tellus tincidunt, mattis magna consectetur, efficitur ante. Sed neque eros, volutpat eu luctus in, ultricies in lectus."
        )

        let description = film.movieDetails.overview ?? "\(film.odeonFilmDetails.plot)\n\n\(film.odeonFilmDetails.customerAdvice)"
        
        let structure: [ItemTypeTuple] = [
            (.rating, nil),
            (.paragraph, nil),
            (.movieInformation, nil),
            (.title, ProfileTitleViewModel(title: "Cast", buttonText: nil, buttonAction: nil)),
            (.scroller, nil),
            (.title, ProfileTitleViewModel(title: "Reviews", buttonText: "SEE ALL", buttonAction: { })),
            (.review, reviewOne),
            (.review, reviewTwo),
            (.button, ProfileButtonViewModel(buttonText: "SEE ALL REVIEWS", buttonAction: { })),
            (.title, ProfileTitleViewModel(title: "Photogallery", buttonText: nil, buttonAction: nil)),
            (.gallery, nil)
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
