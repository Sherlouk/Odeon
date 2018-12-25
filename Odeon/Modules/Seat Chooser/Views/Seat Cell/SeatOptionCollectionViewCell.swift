//
//  SeatOptionCollectionViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 25/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class SeatOptionCollectionViewCell: UICollectionViewCell {
    
    typealias SeatStatus = BookingInit.Section.SeatsData.Seat.SeatStatus
    
    @IBOutlet var seatImageView: UIImageView!
    
    var seat: BookingInit.Section.SeatsData.Seat!
    
    func configure(section: BookingInit.Section, seat: BookingInit.Section.SeatsData.Seat) {
        self.seat = seat
        seatImageView.image = seatImageView.image?.withRenderingMode(.alwaysTemplate)
        seatImageView.tintColor = color(for: seat.state, selected: isSelected)
    }
    
    func color(for state: SeatStatus, selected: Bool) -> UIColor {
        
        if selected {
            return .red
        }
        
        switch state {
        case .free: return .white
        default: return UIColor.white.withAlphaComponent(0.2)
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            seatImageView.tintColor = color(for: seat.state, selected: isSelected)
        }
    }
    
}
