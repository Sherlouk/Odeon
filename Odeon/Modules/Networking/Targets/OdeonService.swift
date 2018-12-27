//
//  OdeonService.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import Moya

enum OdeonBaseURL: String {
    
    case UK
    case ireland
    
    var baseURL: URL {
        switch self {
        case .UK: return URL(string: "https://api.odeon.co.uk/android-3.6.0/")!
//        case .ireland: return URL(string: "https://api.odeoncinemas.ie/android-3.6.0/")!
        case .ireland: return URL(string: "https://api.odeon.co.uk/android-3.6.0/")!
        }
        
        // I have been unable to identify the v2BaseURL for users in Ireland which means cinema IDs
        // can not be mapped for Irish cinemas. For that reason despite your option, it just uses UK
        // Until I can figure that issue out (but I wanted to demonstrate that you "could" switch.
    }
    
    var v2BaseURL: URL {
        switch self {
        case .UK: return URL(string: "https://www.odeon.co.uk/api/uk/v2/")!
        case .ireland: return URL(string: "https://www.odeon.co.uk/api/uk/v2/")!
        }
    }
    
    static var current: OdeonBaseURL {
        let rawValue = OdeonStorage().userChosenCountry ?? UK.rawValue
        return OdeonBaseURL(rawValue: rawValue) ?? .UK
    }
    
}

enum OdeonService {
    
    case allCinemas
    
    case allActiveFilms
    
    case filmAttributes
    case performanceAttributes
    
    case filmsForCinema(siteID: String, date: String)
    
    case newFilms
    case recommendedFilms
    case topFilms
    case comingSoonFilms
    
    case filmDetails(filmID: String)
    case filmDetailsWithCinemas(filmID: String)
    
    case filmTimes(filmID: String, siteID: String)
    
    case bookingInit(performanceID: String, siteID: String)
    
}

extension OdeonService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .allCinemas: return OdeonBaseURL.current.v2BaseURL
        default: return OdeonBaseURL.current.baseURL
        }
        
    }
    
    var path: String {
        switch self {
        case .allCinemas: return "cinemas.json"
        case .allActiveFilms: return "api/all-current-active-films"
        case .filmAttributes: return "api/film-attributes"
        case .performanceAttributes: return "api/performance-attributes"
        case .filmsForCinema(let siteID, let date): return "api/films-by-cinema/s/\(siteID)/date/\(date)"
        case .newFilms: return "api/new-films"
        case .recommendedFilms: return "api/recommended-films"
        case .topFilms: return "api/top-films"
        case .comingSoonFilms: return "api/coming-soon-films"
        case .filmDetails(let filmID): return "api/film-details/m/\(filmID)"
        case .filmDetailsWithCinemas(let filmID): return "api/film-details-with-cinemas/m/\(filmID)"
        case .filmTimes(let filmID, let siteID): return "api/film-times/m/\(filmID)/s/\(siteID)"
        case .bookingInit: return "booking_standard/booking-init"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    var sampleData: Data {
        fatalError("Unimplemented")
    }
    
    var task: Task {
        switch self {
        case .bookingInit(let performanceID, let siteID):
            return .requestParameters(parameters: [
                "p": performanceID,
                "s": siteID
            ], encoding: URLEncoding.default) // Form URLEncoded Data
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
