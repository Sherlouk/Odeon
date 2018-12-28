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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    
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
    }

}
