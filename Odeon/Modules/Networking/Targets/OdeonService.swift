//
//  OdeonService.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import Moya

enum OdeonBaseURL {
    
    case UK
    case ireland
    
    var baseURL: URL {
        switch self {
        case .UK: return URL(string: "https://api.odeon.co.uk/android-3.6.0/")!
        case .ireland: return URL(string: "https://api.odeoncinemas.ie/android-3.6.0/")!
        }
    }
    
    static var current: OdeonBaseURL {
        // TODO: Make this user-configurable
        return .UK
    }
    
}

enum OdeonService {
    
    case allCinemas
    
    case allActiveFilms
    
    case filmAttributes
    case performanceAttributes
    
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
        return OdeonBaseURL.current.baseURL
    }
    
    var path: String {
        switch self {
        case .allCinemas: return "api/all-cinemas"
        case .allActiveFilms: return "api/all-current-active-films"
        case .filmAttributes: return "api/film-attributes"
        case .performanceAttributes: return "api/performance-attributes"
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
