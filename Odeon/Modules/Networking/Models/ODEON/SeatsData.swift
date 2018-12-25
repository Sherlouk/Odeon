//
//  SeatsData.swift
//  Odeon
//
//  Created by Sherlock, James on 25/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct SeatsData: Codable {
    
    enum Error: Swift.Error {
        case notAnInt
    }
    
    struct Seat {
        
        enum SeatType: Int {
            case regular = 1
            case love
            case wheelchair
            case house
            case removable
            case unknown = -1
        }
        
        enum SeatStatus: Int {
            case broken = 0
            case blocked
            case free
            case reserved
            case sold
            case prepaid
            case lockedForSale
            case lockedForReservations
            case lockedForSaleAndReservations = 13
            case unknown = -1
        }
        
        let seatNumber: Int
        let x: Int
        let y: Int
        let width: Int
        let height: Int
        let type: SeatType
        let neighbourLeft: Int
        let neighbourRight: Int
        let state: SeatStatus
        
        init(components: [Int]) {
            seatNumber = components[0]
            x = components[1]
            y = components[2]
            width = components[3]
            height = components[4]
            type = SeatType(rawValue: components[5]) ?? .unknown
            neighbourLeft = components[6]
            neighbourRight = components[7]
            state = SeatStatus(rawValue: components[8]) ?? .unknown
        }
        
        var encoded: String {
            return [
                seatNumber,
                x,
                y,
                width,
                height,
                type.rawValue,
                neighbourLeft,
                neighbourRight,
                state.rawValue
            ].map(String.init)
             .joined(separator: "|")
        }
        
        var isBookable: Bool {
            return state == .free
        }
    }
    
    let seats: [Seat]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let seats = rawValue.components(separatedBy: ";")
        
        var builder = [Seat]()
        
        for seat in seats {
            let components: [Int] = try seat.components(separatedBy: "|").map({
                guard let int = Int($0) else {
                    throw Error.notAnInt
                }
                
                return int
            })
            
            builder.append(Seat(components: components))
        }
        
        self.seats = builder
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let string = seats.map({ $0.encoded }).joined(separator: ";")
        try container.encode(string)
    }
    
}
