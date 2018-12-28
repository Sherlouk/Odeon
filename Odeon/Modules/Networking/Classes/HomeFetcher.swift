//
//  HomeFetcher.swift
//  Odeon
//
//  Created by Sherlock, James on 27/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

class HomeFetcher {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    struct Payload {
        let cinemaFilms: [OdeonFilmInCinema.Film]
        let newFilms: [OdeonFilm]
        let topFilms: [OdeonFilm]
        let recommendedFilms: [OdeonFilm]
        let comingSoonFilms: [OdeonFilm]
    }
    
    // MARK: - Fetch
    
    func fetch() -> Promise<Payload> {
        let provider = MoyaProvider<OdeonService>()
        
        // Defaulting to "0" is actually the same as the 1st Party app, fun fact.
        // Should never happen once we have onboarding implemented
        // TODO: Update this comment once we have onboarding
        let siteID = String(OdeonStorage().userChosenCinema ?? 0)
        
        let date = HomeFetcher.dateFormatter.string(from: Date())
        
        return when(fulfilled:
            provider.requestDecodePromise(.filmsForCinema(siteID: siteID, date: date), type: DataWrapperGenericResponse<[OdeonFilmInCinema]>.self),
            provider.requestDecodePromise(.newFilms, type: ListFilmsResponse.self),
            provider.requestDecodePromise(.topFilms, type: ListFilmsResponse.self),
            provider.requestDecodePromise(.recommendedFilms, type: ListFilmsResponse.self),
            provider.requestDecodePromise(.comingSoonFilms, type: ListFilmsResponse.self)
        ).map({ (responses) -> HomeFetcher.Payload in
            
            return Payload(
                cinemaFilms: responses.0.data.map({ $0.film }),
                newFilms: responses.1.data.films,
                topFilms: responses.2.data.films,
                recommendedFilms: responses.3.data.films,
                comingSoonFilms: responses.4.data.films
            )
            
        })
        
    }
    
}
