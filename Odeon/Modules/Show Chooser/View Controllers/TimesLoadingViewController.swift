//
//  TimesLoadingViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TimesLoadingViewController: UIViewController, IndicatorInfoProvider, StoryboardLoadable {
    
    static var storyboardName: String {
        return "ShowChooser"
    }
    
    static var viewControllerIdentifier: String? {
        return "Loading"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Loading")
    }
    
}
