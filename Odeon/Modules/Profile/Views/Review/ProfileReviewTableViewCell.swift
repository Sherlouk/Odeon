//
//  ProfileReviewTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ProfileReviewTableViewCell: UITableViewCell, ConfigurableCell {

    // MARK: - Outlets
    
    @IBOutlet var revieweeImageView: UIImageView!
    @IBOutlet var revieweeNameLabel: UILabel!
    
    @IBOutlet var reviewDateLabel: UILabel!
    @IBOutlet var reviewStarsContainer: UIStackView!
    
    @IBOutlet var reviewDescriptionLabel: UILabel!
    
    // MARK: - Configuration
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ProfileReviewViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        setStarCount(viewModel.halfRating)
        
        revieweeNameLabel.text = viewModel.revieweeName
        reviewDescriptionLabel.text = viewModel.reviewDescription
        
        // TODO: Set Date and Image
        
    }
    
    // MARK: - Stars
    
    /// Set star count based on half rating.
    ///
    /// Example: 9 would become a 4.5 out of 5
    func setStarCount(_ halfRating: Int) {
        
        // Collect and validate assets
        
        let fullImage = UIImage(named: "Star/filled")?.withRenderingMode(.alwaysTemplate)
        let halfImage = UIImage(named: "Star/half")?.withRenderingMode(.alwaysTemplate)
        
        assert(fullImage != nil)
        assert(halfImage != nil)
        
        let activeColour = UIColor(named: "Profile/StarActive")
        let inactiveColour = UIColor(named: "Profile/StarInactive")
        
        assert(activeColour != nil)
        assert(inactiveColour != nil)
        
        // Define helper blocks for mapping star to assets
        
        let imageForRating: (Int) -> UIImage? = { tag in
            
            if halfRating >= tag * 2 {
                return fullImage
            }
            
            if halfRating >= (tag * 2) - 1 {
                return halfImage
            }
            
            return fullImage
            
        }
        
        let colourForRating: (Int) -> UIColor? = { tag in
            
            if halfRating >= (tag * 2) - 1 {
                return activeColour
            }
            
            return inactiveColour
            
        }
        
        // Apply assets to each star in container
        
        for view in reviewStarsContainer.arrangedSubviews {
            
            guard let imageView = view as? UIImageView else {
                continue
            }
            
            imageView.image = imageForRating(view.tag)
            imageView.tintColor = colourForRating(view.tag) ?? .black
            
        }
        
    }
    
}
