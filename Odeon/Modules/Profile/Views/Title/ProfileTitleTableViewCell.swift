//
//  ProfileTitleTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ProfileTitleTableViewCell: UITableViewCell, ConfigurableCell {

    @IBOutlet var actionButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var action: VoidClosure?
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ProfileTitleViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        titleLabel.text = viewModel.title
        
        if let actionTitle = viewModel.buttonText {
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
        
        action = viewModel.buttonAction
        
    }
    
    @IBAction func didTapButton() {
        assertNotNil(action)
        action?()
    }
    
}
