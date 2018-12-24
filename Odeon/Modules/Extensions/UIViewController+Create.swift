//
//  UIViewController+Create.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

protocol StoryboardLoadable {
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String? { get }
}

extension StoryboardLoadable where Self: UIViewController {
    
    static var viewControllerIdentifier: String? {
        return nil
    }
    
    static func create() -> Self {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let identifier = viewControllerIdentifier {
            guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
                fatalError("Failed to load or cast view controller with identifier: \(identifier)")
            }
            
            return viewController
        }
        
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Failed to load or cast initial view controller in storyboard: \(storyboardName)")
        }
        
        return viewController
        
    }
    
}
