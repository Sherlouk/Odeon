//
//  MovieDetails.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct MovieDetails: Codable {
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
    
    // https://developers.themoviedb.org/3/movies/get-movie-details
    
    let backdrop_path: String?
    let original_title: String
    let overview: String?
    let tagline: String?
    
    let vote_count: Int
    let vote_average: Float
    let popularity: Float
    
    let imdb_id: String?
    let homepage: URL?
    let genres: [Genre]
    
}
