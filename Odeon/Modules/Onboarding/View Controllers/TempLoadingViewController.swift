//
//  TempLoadingViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import PromiseKit
import Squawk

class TempLoadingViewController: UIViewController, StoryboardLoadable {

    // MARK: - StoryboardLoadable
    
    static var storyboardName: String {
        return "Onboarding"
    }
    
    static var viewControllerIdentifier: String? {
        return "TempLoader"
    }
    
    // MARK: - Variables
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var onCompletion: ((OdeonPreloadFetcher.Preload, HomeFetcher.Payload) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
    }
    
    // MARK: - Loading
    
    func startLoading() {
        
        firstly {
            when(fulfilled:
                OdeonPreloadFetcher().fetch(),
                HomeFetcher().fetch()
            )
        }.ensure {
            self.activityIndicator.stopAnimating()
        }.done { preload, homePayload in
            self.onCompletion?(preload, homePayload)
        }.catch { error in
            Squawk.shared.showError(error: error)
        }
    }

}
