//
//  CinemaListingTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class CinemaListingTableViewCell: UITableViewCell {

    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var cinemaNameLabel: UILabel!
    @IBOutlet var luxeButton: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = selected ? UIColor.white.withAlphaComponent(0.05) : .clear
        accessoryType = selected ? .checkmark : .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Intentionally empty
    }
    
    func configure(with cinema: Cinema) {
        cinemaNameLabel.text = cinema.name.replacingOccurrences(of: "- ODEON Luxe", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        luxeButton.isHidden = !cinema.isLuxe
        
        let distance = "(1 mile away)"
        locationLabel.text = "\(cinema.address.line1)\n\(distance)"
    }
    
    @IBAction func didTapFavourite() {
        print("Favourite")
    }
    
    @IBAction func didTapLuxe() {
        print("Luxe")
    }
    
}
