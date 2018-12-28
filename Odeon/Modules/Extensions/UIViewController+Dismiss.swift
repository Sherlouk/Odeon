//
//  UIViewController+Dismiss.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func dismiss() {
        dismiss(animated: trueUnlessReduceMotionEnabled, completion: nil)
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: trueUnlessReduceMotionEnabled, completion: nil)
    }
    
}

extension UINavigationController {
    
    func push(_ viewController: UIViewController) {
        pushViewController(viewController, animated: trueUnlessReduceMotionEnabled)
    }
    
}
