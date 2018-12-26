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

class HomeViewController: UIViewController, StoryboardLoadable {

    static var storyboardName: String {
        return "Home"
    }
    
    static var viewControllerIdentifier: String? {
        return "Home"
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var preload: OdeonPreloadFetcher.Preload!
    
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
                            print("Completed downloading movie... \(film2.movieDetails.imdb_id)")

                            let vc = ProfileViewController.create(with: FilmDetailsStructureMapper(film: film2))
                            vc.film = film2
                            vc.preload = self.preload
                            vc.hidesBottomBarWhenPushed = true
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
