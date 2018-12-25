//
//  BookingInit.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct BookingInit: Codable {
    
    struct HeaderData: Codable {
        
        static var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            formatter.locale = Locale(identifier: "en_GB_POSIX")
            
            return formatter
        }()
        
        enum Error: Swift.Error {
            case failedToParseDate
            case incorrectNumberOfComponents
        }
        
        enum CodingKeys: String, CodingKey {
            case filmTitle
            case formatedHeader // Yes, it's spelt wrong in the API
        }
        
        let filmTitle: String
        let filmTime: Date
        let cinemaName: String
        let screenName: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let title = try container.decode(String.self, forKey: .filmTitle)
            let header = try container.decode(String.self, forKey: .formatedHeader)
            
            filmTitle = title
            
            let headerComponents = header.components(separatedBy: "|").map({ $0.trimmingCharacters(in: .whitespaces) })
            
            guard headerComponents.count == 3 else {
                throw Error.incorrectNumberOfComponents
            }
            
            guard let date = HeaderData.dateFormatter.date(from: headerComponents[0]) else {
                print(headerComponents[0])
                throw Error.failedToParseDate
            }
            
            filmTime = date
            cinemaName = headerComponents[1]
            screenName = headerComponents[2]
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            let builder = [
                HeaderData.dateFormatter.string(from: filmTime),
                cinemaName,
                screenName
            ].joined(separator: " | ")
            
            try container.encode(filmTitle, forKey: .filmTitle)
            try container.encode(builder, forKey: .formatedHeader)
        }
    }
    
    struct Fees: Codable {
        struct CardHandlingFee: Codable {
            let infoTextTicketSelection: String
            let infoTextRunningTotal: String
            let fee: Float
        }
        
        let cardHandlingFee: CardHandlingFee
    }
    
    struct SeatPlanSize: Codable {
        enum CodingKeys: String, CodingKey {
            case width = "seatingPlanWidth"
            case height = "seatingPlanHeight"
        }
        
        let width: Int
        let height: Int
    }
    
    struct Section: Codable {
        struct Color: Codable {
            let red: Float
            let green: Float
            let blue: Float
        }
        
        enum Mode: String, Codable {
            case unreserved
            case reserved
            case bestAvailable
        }
        
        struct Tickets: Codable {
            struct Price: Codable {
                let id: String
                let chunk: Int
                let name: String
                let subscription: String
                let amount: Float
                let count: Int
                let is3d: Bool
            }
            
            let `default`: [Price]
            let threeD: [Price]
        }
        
        let name: String
        let mode: Mode
        let color: Color
        let seatsString: SeatsData
    }
    
    let headerData: HeaderData
    let fees: Fees
    let seatPlanSize: SeatPlanSize
    let sections: [Section]
}
