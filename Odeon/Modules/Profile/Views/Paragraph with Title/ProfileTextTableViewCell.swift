//
//  ProfileTextTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ProfileTextTableViewCell: UITableViewCell, ConfigurableCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ProfileTextViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        titleLabel.text = viewModel.title
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.lineSpacing = 1
        
        descriptionLabel.attributedText = NSAttributedString(
            string: viewModel.text,
            attributes: [
                .font: descriptionLabel.font,
                .foregroundColor: descriptionLabel.textColor,
                .paragraphStyle: paragraphStyle
            ]
        )
        
    }
    
}
