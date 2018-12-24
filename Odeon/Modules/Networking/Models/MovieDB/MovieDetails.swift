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
    
    struct ExternalIds: Codable {
        let imdb_id: String?
        let facebook_id: String?
        let instagram_id: String?
        let twitter_id: String?
    }
    
    struct Credits: Codable {
        struct CastMember: Codable {
            let id: Int
            let character: String
            let name: String
            let profile_path: MDBImageURL
        }
        
        struct CrewMember: Codable {
            let id: Int
            let job: String
            let name: String
            let department: String
            let profile_path: String?
        }
        
        let cast: [CastMember]
        let crew: [CrewMember]
    }
    
    // https://developers.themoviedb.org/3/movies/get-movie-details
    
    let backdrop_path: MDBImageURL
    let poster_path: MDBImageURL
    let title: String
    let overview: String?
    let tagline: String?
    
    let vote_count: Int
    let vote_average: Float
    let popularity: Float
    
    let imdb_id: String?
    let homepage: URL?
    let genres: [Genre]
    let external_ids: ExternalIds?
    let credits: Credits?
    let release_date: DateWrapper<YearMonthDayDashed>
    
}
