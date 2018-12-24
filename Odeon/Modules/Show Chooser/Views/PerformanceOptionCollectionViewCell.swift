//
//  PerformanceOptionCollectionViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class PerformanceOptionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 2
    }
    
    override var isSelected: Bool {
        didSet {
            let deselected = UIColor(named: "Profile/SecondaryText")
            let selected = UIColor(named: "Profile/PrimaryText")
            let colour = isSelected ? selected : deselected
            
            containerView.layer.borderColor = colour?.cgColor
            timeLabel.textColor = colour
            descriptionLabel.textColor = colour
        }
    }
    
}
