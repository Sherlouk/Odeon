//
//  ShowChooserViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import Moya

class ShowChooserViewController: UIViewController {

    struct ViewModel {
        let siteID: String
        let preload: OdeonPreloadFetcher.Preload
        let film: FilmFetcher.Film
    }
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var filmTitleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var ctaContainerView: UIView!
    @IBOutlet var ctaButton: UIButton!
    @IBOutlet var ctaIndicatorImageView: UIImageView!
    
    class func create(viewModel: ViewModel) -> ShowChooserViewController {
        let storyboard = UIStoryboard(name: "ShowChooser", bundle: nil)

        guard let vc = storyboard.instantiateInitialViewController() as? ShowChooserViewController else {
            fatalError()
        }
        
        vc.viewModel = viewModel
        
        return vc
    }
    
    var viewModel: ViewModel!
    var performance: Performance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupHeader()
        setupCallToAction()
        loadTimes()
    }
    
    // MARK: - Loading
    
    func loadTimes() {
        let provider = MoyaProvider<OdeonService>()
        let request: OdeonService = .filmTimes(filmID: viewModel.film.id, siteID: viewModel.siteID)
        let promise = provider.requestDecodePromise(request, type: DataWrapperGenericResponse<[FilmTimes]>.self)
        
        promise.done { times in
            self.reloadTimes(data: times.data)
        }.catch { error in
            print(error)
        }
    }
    
    func reloadTimes(data: [FilmTimes]) {
        
        guard let dayChooserViewController = children.compactCast(target: DayChooserViewController.self).first else {
            return
        }
        
        dayChooserViewController.onPerformanceChange = { performance in
            self.performance = performance
            self.updateCallToActionButtonText()
        }
        
        dayChooserViewController.data = data
        
    }
    
    // MARK: - Navigation
    
    func setupNavigationBar() {
        
        guard let controller = navigationController as? TransparentNavigationViewController else {
            return
        }
        
        navigationItem.leftBarButtonItem = controller.backButton
        
    }
    
    // MARK: - Header
    
    func setupHeader() {
        filmTitleLabel.text = viewModel.film.movieDetails.title
        headerImageView.kf.setImage(with: viewModel.film.movieDetails.backdrop_path.makeURL())
    }
    
    // MARK: - Call to Action
    
    var ctaGradientLayer: CAGradientLayer?
    
    func setupCallToAction() {
        let layer = CAGradientLayer()
        layer.frame = ctaContainerView.bounds
        
        layer.colors = [
            UIColor(red: 254 / 255, green: 132 / 255, blue: 92 / 255, alpha: 1).cgColor,
            UIColor(red: 253 / 255, green: 88 / 255, blue: 94 / 255, alpha: 1).cgColor,
            UIColor(red: 189 / 255, green: 63 / 255, blue: 117 / 255, alpha: 1).cgColor
        ]
        
        layer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.5),
            NSNumber(value: 1)
        ]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
        ctaGradientLayer = layer
        ctaContainerView.layer.insertSublayer(layer, at: 0)
        updateCallToActionButtonText(initial: true)
    }
    
    func updateCallToActionButtonText(initial: Bool = false) {
        if performance == nil {
            ctaButton.setTitle("CHOOSE SHOWING", for: .normal)
            ctaButton.setTitleColor(UIColor(named: "Profile/PrimaryText")?.withAlphaComponent(0.6), for: .normal)
            ctaButton.isEnabled = false
        } else {
            ctaButton.setTitle("CHOOSE SEATS", for: .normal)
            ctaButton.setTitleColor(UIColor(named: "Profile/PrimaryText"), for: .normal)
            ctaButton.isEnabled = true
        }
        
        UIView.transition(
            with: ctaButton,
            duration: trueUnlessReduceMotionEnabled && !initial ? 0.3 : 0,
            options: [ .beginFromCurrentState ],
            animations: {
                self.ctaIndicatorImageView.alpha = self.performance == nil ? 0 : 1
            },
            completion: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ctaGradientLayer?.frame = ctaContainerView.bounds
    }

    @IBAction func didTapCallToAction() {
        guard let performance = performance else {
            return
        }
        
        let viewController = SeatChooserViewController.create()
        viewController.viewModel = .init(performanceID: performance.id, siteID: viewModel.siteID)
        
        navigationController?.pushViewController(viewController, animated: trueUnlessReduceMotionEnabled)
    }
    
}
