//
//  MembersViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController, StoryboardLoadable {

    static var storyboardName: String {
        return "Home"
    }
    
    static var viewControllerIdentifier: String? {
        return "Members"
    }
    
    // Class purely for the StoryboardLoadable convenience method
    
    // This view controller is not implemented and is purely to
    // fill out the tab bar similar to a "real" implementation

    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
