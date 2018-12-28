//
//  FilmDetailsStructureMapper.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class FilmDetailsStructureMapper: ProfileStructureMapper {
    
    typealias ItemTypeTuple = (itemType: ProfileItemType, object: Any?)
    
    let film: FilmFetcher.Film
    var cachedStructure: [ItemTypeTuple]?
    
    var stretchyHeaderViewModel: ProfileStretchyHeaderViewModel?
    var callToActionViewModel: ProfileCallToActionViewModel?
    var actionHandler: ProfileActionHandler?
    var sharableItems: [String]?
    
    init(film: FilmFetcher.Film) {
        self.film = film
        setStretchyHeader()
        setCallToAction()
        setSharing()
    }
    
    func setStretchyHeader() {
        stretchyHeaderViewModel = ProfileStretchyHeaderViewModel(
            title: film.movieDetails.title,
            description: "(\(film.movieDetails.release_date.year))",
            imageURL: film.movieDetails.backdrop_path.makeURL()!,
            tags: film.movieDetails.genres.map({ $0.name })
        )
    }
    
    func setCallToAction() {
        callToActionViewModel = ProfileCallToActionViewModel(
            action: .openFilmShowChooser(film: film)
        )
    }
    
    func setSharing() {
        sharableItems = [
            film.movieDetails.title,
            film.odeonFilmDetails.plot
        ]
    }
    
    var structure: [ItemTypeTuple] {
        
        if let cached = cachedStructure {
            return cached
        }
        
        let description = film.movieDetails.overview ?? "\(film.odeonFilmDetails.plot)\n\n\(film.odeonFilmDetails.customerAdvice ?? "")"
        
        var castViewModels: [ScrollerImageViewModel]?
        
        if let initialCast = film.movieDetails.credits?.cast.prefix(10) {
            castViewModels = Array(initialCast).map({ castMember in
                ScrollerImageViewModel(
                    title: castMember.name,
                    imageURL: castMember.profile_path.makeURL(),
                    aspectRatio: .headshot,
                    tapAction: .openCastMember(id: castMember.id),
                    secondaryText: castMember.character,
                    halfRating: nil,
                    certificate: nil
                )
            })
        }
        
        let movieInformation = MovieInformationViewModel(
            runningTime: Int(film.odeonFilmDetails.runningTime ?? "-1") ?? -1,
            language: film.odeonFilmDetails.language,
            releaseDate: film.movieDetails.release_date.date,
            certificate: film.odeonFilmDetails.certificate,
            director: film.odeonFilmDetails.director,
            posterImageURL: film.movieDetails.poster_path.makeURL()!
        )
        
        let structure: [ItemTypeTuple] = [
            (.rating, ProfileRatingViewModel(reviewCount: film.movieDetails.vote_count, reviewAverage: film.movieDetails.vote_average)),
            (.paragraph, ProfileTextViewModel(title: "Overview", text: description)),
            (.movieInformation, movieInformation),
            (.title, ProfileTitleViewModel(title: "Cast and Crew", buttonText: "SEE ALL", buttonAction: {
                self.actionHandler?.handleAction(action: .openAllCast(film: self.film))
            })),
            (.scroller, HorizontalScrollerViewModel(itemSize: CGSize(width: 140, height: 260), contents: castViewModels)),
            (.title, ProfileTitleViewModel(title: "On The Web", buttonText: nil, buttonAction: nil)),
            (.social, nil),
            (.copyright, nil)
        ]
        
        self.cachedStructure = structure
        return structure
        
    }
    
    
}
