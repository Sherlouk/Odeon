//
//  HomeViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import Moya
import Result

// TODO: THIS IS A TEMPORARY VIEW CONTROLLER

class HomeViewController: UIViewController {

    class func create() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? HomeViewController else {
            fatalError()
        }
        
        return vc
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressLaunch(_ sender: UIButton) {
        sender.isHidden = true
        activityIndicator.startAnimating()
        
        // DO NETWORKING
        
        let provider = MoyaProvider<OdeonService>()
        
        provider.requestDecode(.topFilms) { (result: Result<ListFilmsResponse, MoyaError>) in
            
            self.activityIndicator.stopAnimating()
            sender.isHidden = false
            
            switch result {
            case .success(let response):
                let film = response.data.films.first
                print(film)
                
            case .failure(let error):
                print(error)
            }
        }
        

        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
