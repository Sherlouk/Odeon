//
//  FilmTimes.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct FilmTimes: Codable {
    
    struct Day: Codable {
        let date: DateWrapper<YearMonthDayDashed>
        let performances: [Performance]
    }
    
    let attribute: String
    let days: [Day]
    
}
