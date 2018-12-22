//
//  ProfileStretchyHeaderView.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView
import Kingfisher

class ProfileStretchyHeaderView: GSKStretchyHeaderView, ConfigurableCell {
    
    @IBOutlet var titleNavigationBarLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var titleToSecondaryConstraint: NSLayoutConstraint!
    @IBOutlet var titleContainerView: UIView!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tagButton: UIButton!
    
    var gradientLayer: CAGradientLayer?
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        expansionMode = .topOnly
        maximumContentHeight = bounds.width // Square
        
        tagButton.layer.borderWidth = 1
        tagButton.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        tagButton.layer.cornerRadius = 5
        
        setupGradientView()
    }
    
    func setupGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        
        gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.3),
            NSNumber(value: 1)
        ]
        
        gradientView.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    // MARK: - Configure
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ProfileStretchyHeaderViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        titleLabel.text = viewModel.title
        titleNavigationBarLabel.text = viewModel.title
        
        secondaryLabel.text = viewModel.description
        secondaryLabel.isHidden = viewModel.description == nil
        titleToSecondaryConstraint.isActive = !secondaryLabel.isHidden
        
        tagButton.setTitle(viewModel.tagTitle, for: .normal)
        
        backgroundImageView.kf.setImage(with: viewModel.imageURL)
    }
    
    // MARK: - Stretch Adaptation
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        var viewAlpha = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1)
        viewAlpha = max(0, min(1, viewAlpha))
        
        tagButton.alpha = viewAlpha
        titleContainerView.alpha = viewAlpha
        
        var secondViewAlpha = CGFloatTranslateRange(stretchFactor, 0, 0.4, 1, 0)
        secondViewAlpha = max(0, min(1, secondViewAlpha))
        
        titleNavigationBarLabel.alpha = secondViewAlpha
    }
    
}
