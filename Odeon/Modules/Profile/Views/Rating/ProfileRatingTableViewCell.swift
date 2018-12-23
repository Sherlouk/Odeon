//
//  ProfileRatingTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ProfileRatingTableViewCell: UITableViewCell, ConfigurableCell {

    @IBOutlet var userRatingBottomLabel: UILabel!
    @IBOutlet var userRatingTopLabel: UILabel!
    @IBOutlet var userRatingImageView: UIImageView!
    
    @IBOutlet var movieRatingImageView: UIImageView!
    @IBOutlet var movieRatingLabel: UILabel!
    @IBOutlet var movieRatingCountLabel: UILabel!
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ProfileRatingViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        let ratingText = NSMutableAttributedString(string: "\(viewModel.reviewAverage)", attributes: [
            .font: movieRatingLabel.font,
            .foregroundColor: movieRatingLabel.textColor,
        ])
        
        ratingText.append(NSAttributedString(string: " / 10", attributes: [
            .font: movieRatingLabel.font.withSize(movieRatingLabel.font.pointSize - 4),
            .foregroundColor: movieRatingLabel.textColor,
        ]))
        
        movieRatingLabel.attributedText = ratingText
        movieRatingCountLabel.text = "\(viewModel.reviewCount) Reviews"
        movieRatingImageView.image = UIImage(named: "Icons/Star/filled")?.withRenderingMode(.alwaysTemplate)
        movieRatingImageView.tintColor = UIColor(named: "Profile/StarActive")
        
        userRatingImageView.image = UIImage(named: "Icons/Star/empty")?.withRenderingMode(.alwaysTemplate)
        userRatingImageView.tintColor = UIColor(named: "Profile/StarActive")
    }
    
}
