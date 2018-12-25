//
//  HomeViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import Moya
import enum Result.Result
import PromiseKit
import Squawk
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
    var preload: OdeonPreloadFetcher.Preload!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        activityIndicator.startAnimating()
        
        // this is all temp garbage until I get a better bootloading/home setup
        firstly {
            OdeonPreloadFetcher().fetch()
        }.done { preload in
            self.preload = preload
            self.activityIndicator.stopAnimating()
        }.catch { error in
            Squawk.shared.show(config: Squawk.Configuration(text: error.localizedDescription))
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressLaunch(_ sender: UIButton) {
        sender.isHidden = true
        activityIndicator.startAnimating()
        
        // DO NETWORKING
        
        let provider = MoyaProvider<OdeonService>()
        
        provider.requestDecode(.topFilms) { (result: Result<ListFilmsResponse, MoyaError>) in
            
            switch result {
            case .success(let response):
                if let film = response.data.films.first {
                    print("Found ODEON film... \(film.id)")
                    FilmFetcher(film: film).fetch(completion: { result in
                        
                        self.activityIndicator.stopAnimating()
                        sender.isHidden = false
                        
                        switch result {
                        case .failure(let error):
                            print(error)
                            
                        case .success(let film2):
//                            print(film2)
                            print("Completed downloading movie...")
                            let vc = ProfileViewController.create(with: FilmDetailsStructureMapper(film: film2))
                            vc.film = film2
                            vc.preload = self.preload
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                    })
                } else {
                    print("No ODEON film")
                }
                
                
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
