//
//  CastDetails.swift
//  Odeon
//
//  Created by Sherlock, James on 28/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct CastDetails: Codable {
    
    struct MovieCredits: Codable {
        
        // https://developers.themoviedb.org/3/people/get-person-movie-credits
        
        struct CastMember: Codable {
            let character: String?
            let title: String
            let poster_path: MDBImageURL
        }
        
        struct CrewMember: Codable {
            let job: String
        }
        
        let cast: [CastMember]
        let crew: [CrewMember]
    }
    
    struct ExternalIds: Codable {
        
        // https://developers.themoviedb.org/3/people/get-person-external-ids
        
        let facebook_id: String?
        let imdb_id: String?
        let twitter_id: String?
        let instagram_id: String?
    }
    
    enum Gender: Int, Codable {
        case unknown
        case female
        case male
    }
    
    // https://developers.themoviedb.org/3/people/get-person-details
    
    let birthday: DateWrapper<YearMonthDayDashed>?
    let known_for_department: String
    let name: String
    let gender: Gender
    let biography: String
    let place_of_birth: String?
    let profile_path: MDBImageURL?
    let homepage: URL?
    let movie_credits: MovieCredits
    
}
