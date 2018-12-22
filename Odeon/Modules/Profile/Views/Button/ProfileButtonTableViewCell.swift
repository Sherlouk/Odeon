//
//  ProfileButtonTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ProfileButtonTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet var mainButton: UIButton!
    var action: VoidClosure?
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? ProfileButtonViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        mainButton.setTitle(viewModel.buttonText, for: .normal)
        action = viewModel.buttonAction
        
    }
    
    @IBAction func didTapButton() {
        assertNotNil(action)
        action?()
    }
    
}
