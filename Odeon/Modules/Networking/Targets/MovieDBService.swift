//
//  MovieDBService.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import Moya

enum MovieDBService {
    
    case searchMovie(query: String, year: Int)
    case getMovieDetails(movieID: Int)
    case getCastDetails(personID: Int)
    
}

extension MovieDBService: TargetType {
    
    // TODO: Pass through device language locale to translate responses?
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .searchMovie: return "search/movie"
        case .getMovieDetails(let movieID): return "movie/\(movieID)"
        case .getCastDetails(let personID): return "person/\(personID)"
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
        case .searchMovie(query: let query, year: let year):
            return .requestParameters(parameters: [
                "api_key": apiKey,
                "query": query,
                "year": year,
                "primary_release_year": year
            ], encoding: URLEncoding.queryString)
        case .getMovieDetails:
            return .requestParameters(parameters: [
                "api_key": apiKey,
                "append_to_response": ["credits", "external_ids"].joined(separator: ",")
            ], encoding: URLEncoding.queryString)
        case .getCastDetails:
            return .requestParameters(parameters: [
                "api_key": apiKey,
                "append_to_response": ["movie_credits", "external_ids"].joined(separator: ",")
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var apiKey: String {
        return ProcessInfo.processInfo.environment["MOVIEDB_API_KEY"]!
    }
    
}
