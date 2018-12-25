//
//  SeatOptionCollectionViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 25/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class SeatOptionCollectionViewCell: UICollectionViewCell {
    
    typealias SeatStatus = SeatsData.Seat.SeatStatus
    
    @IBOutlet var seatImageView: UIImageView!
    
    var seat: SeatsData.Seat!
    
    func configure(section: BookingInit.Section, seat: SeatsData.Seat) {
        self.seat = seat
        seatImageView.image = seatImageView.image?.withRenderingMode(.alwaysTemplate)
        seatImageView.tintColor = color(for: seat.state, selected: isSelected)
    }
    
    func color(for state: SeatStatus, selected: Bool) -> UIColor {
        if selected {
            return UIColor(named: "Seats/Selected")!
        }
        
        switch state {
        case .free:
            return UIColor(named: "Seats/Available")!
        default:
            return UIColor(named: "Seats/Taken")!
        }
    }
    
    override var isSelected: Bool {
        didSet {
            seatImageView.tintColor = color(for: seat.state, selected: isSelected)
        }
    }
    
}
