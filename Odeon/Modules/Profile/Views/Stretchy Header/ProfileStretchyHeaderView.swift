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
    
    @IBOutlet var navigationGradientView: UIView!
    @IBOutlet var titleNavigationBarLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var titleToSecondaryConstraint: NSLayoutConstraint!
    @IBOutlet var titleContainerView: UIView!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tagStackView: UIStackView!
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        expansionMode = .topOnly
        maximumContentHeight = bounds.width // Square
        
        setupGradientView()
    }
    
    func setupGradientView() {
        let topGradientLayer = CAGradientLayer()
        let bottomGradientLayer = CAGradientLayer()
        
        let screenWidth = UIScreen.main.bounds.width
        let frame = CGRect(origin: .zero, size: CGSize(width: screenWidth, height: screenWidth))
        
        topGradientLayer.frame = frame
        bottomGradientLayer.frame = frame
        
        topGradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.8).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor
        ]
        
        bottomGradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        
        topGradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.5),
            NSNumber(value: 1)
        ]
        
        bottomGradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.3),
            NSNumber(value: 1)
        ]
        
        navigationGradientView.layer.addSublayer(topGradientLayer)
        gradientView.layer.addSublayer(bottomGradientLayer)
        
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
        
        setTags(viewModel.tags)
        
        backgroundImageView.kf.setImage(with: viewModel.imageURL)
        
    }
    
    func setTags(_ tags: [String]) {
        
        for tag in tags {
            tagStackView.addArrangedSubview(createTag(with: tag.uppercased()))
        }
        
    }
    
    func createTag(with title: String) -> UIView {
        
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        
        return button
        
    }
    
    // MARK: - Stretch Adaptation
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        var viewAlpha = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1)
        viewAlpha = max(0, min(1, viewAlpha))
        
        tagStackView.alpha = viewAlpha
        titleContainerView.alpha = viewAlpha
        
        var secondViewAlpha = CGFloatTranslateRange(stretchFactor, 0, 0.4, 1, 0)
        secondViewAlpha = max(0, min(1, secondViewAlpha))
        
        titleNavigationBarLabel.alpha = secondViewAlpha
    }
    
}
