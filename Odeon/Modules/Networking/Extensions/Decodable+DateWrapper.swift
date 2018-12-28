//
//  Decodable+DateWrapper.swift
//  Odeon
//
//  Created by Sherlock, James on 23/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

private var dateWrapperFormatter = DateFormatter()

struct DateWrapper<T: DateFormat>: Codable {
    
    enum Error: Swift.Error {
        case invalidDateFormat
    }
    
    let date: Date
    let year: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawDateString = try container.decode(String.self)
        
        dateWrapperFormatter.dateFormat = T.dateFormat
        
        if let date = dateWrapperFormatter.date(from: rawDateString) {
            self.date = date
            
            let components = Calendar.current.dateComponents([.year], from: date)
            self.year = components.year ?? 0
        } else {
            throw Error.invalidDateFormat
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        dateWrapperFormatter.dateFormat = T.dateFormat
        
        try container.encode(dateWrapperFormatter.string(from: date))
    }
    
}

protocol DateFormat {
    static var dateFormat: String { get }
}

struct YearMonthDayDashed: DateFormat {
    static var dateFormat: String {
        return "yyyy-MM-dd"
    }
}

struct YearMonthDay: DateFormat {
    static var dateFormat: String {
        return "yyyyMMdd"
    }
}
