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
    
}

extension MovieDBService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .searchMovie: return "search/movie"
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
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var apiKey: String {
        return ProcessInfo.processInfo.environment["MOVIEDB_API_KEY"]!
    }
    
}
