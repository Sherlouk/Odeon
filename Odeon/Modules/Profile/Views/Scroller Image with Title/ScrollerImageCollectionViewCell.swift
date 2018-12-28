//
//  ScrollerImageCollectionViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ScrollerImageCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    var aspectRatioConstraint: NSLayoutConstraint?
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var infoContainerView: UIView!
    @IBOutlet var certificateImageView: UIImageView!
    @IBOutlet var starsContainer: UIStackView!
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ScrollerImageViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        titleLabel.text = viewModel.title
        mainImageView.kf.setImage(with: viewModel.imageURL)
        
        let aspectRatio = viewModel.aspectRatio.size.asAspectRatioDecimal
        if aspectRatio != (aspectRatioConstraint?.multiplier ?? 0) {
            aspectRatioConstraint?.isActive = false
            
            aspectRatioConstraint = mainImageView.heightAnchor.constraint(
                equalTo: mainImageView.widthAnchor,
                multiplier: aspectRatio
            )
            
            aspectRatioConstraint?.isActive = true
        }
        
        if let secondaryText = viewModel.secondaryText {
            secondaryLabel.text = secondaryText
            secondaryLabel.isHidden = false
        } else {
            secondaryLabel.isHidden = true
        }
        
        if let certificate = viewModel.certificate, let rating = viewModel.halfRating {
            setStarCount(rating)
            certificateImageView.image = certificate.image
            infoContainerView.isHidden = false
        } else {
            infoContainerView.isHidden = true
        }
    }
    
    // MARK: - Stars
    
    /// Set star count based on half rating.
    ///
    /// Example: 9 would become a 4.5 out of 5
    func setStarCount(_ halfRating: Int) {
        
        // Collect and validate assets
        
        let fullImage = UIImage(named: "Icons/Star/filled")?.withRenderingMode(.alwaysTemplate)
        let halfImage = UIImage(named: "Icons/Star/half")?.withRenderingMode(.alwaysTemplate)
        
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
        
        for view in starsContainer.arrangedSubviews {
            
            guard let imageView = view as? UIImageView else {
                continue
            }
            
            imageView.image = imageForRating(view.tag)
            imageView.tintColor = colourForRating(view.tag) ?? .black
            
        }
        
    }

}
