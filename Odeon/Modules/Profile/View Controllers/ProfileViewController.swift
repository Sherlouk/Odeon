//
//  ProfileViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import SafariServices
import Squawk
import PromiseKit
import Moya

class ProfileViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet var ctaToTableViewConstraint: NSLayoutConstraint!
    @IBOutlet var ctaButton: UIButton!
    @IBOutlet var ctaContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var structureMapper: ProfileStructureMapper!
    var stretchyHeader: ProfileStretchyHeaderView?
    var preload: OdeonPreloadFetcher.Preload!
    
    // MARK: - Create
    
    class func create(with mapper: ProfileStructureMapper) -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? ProfileViewController else {
            fatalError("Initial View Controller Not Set or Invalid Cast")
        }
        
        viewController.structureMapper = mapper
        
        return viewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCellsInTableView()
        setupTableView()
        setupNavigationBar()
        setupCallToAction()
        
        if let viewModel = structureMapper.stretchyHeaderViewModel {
            setupStretchyHeader(viewModel: viewModel)
        }
        
//        setupRefreshControl()
    }
    
    // MARK: - Table View
    
    func setupTableView() {
        tableView.dataSource = self
        
        if structureMapper.stretchyHeaderViewModel == nil {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // If we have a stretchy header then we want it to go right to the top of the device
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func registerCellsInTableView() {
        ProfileItemType.allCases.forEach({
            tableView.register(nibName: $0.nibName)
        })
    }
    
    // MARK: - Navigation
    
    func setupNavigationBar() {
        
        guard let controller = navigationController as? TransparentNavigationViewController else {
            return
        }
        
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationItem.leftBarButtonItem = controller.backButton
        }
        
        if let sharableItems = structureMapper.sharableItems, !sharableItems.isEmpty {
            navigationItem.rightBarButtonItem = controller.shareButton
        }
        
    }
    
    // MARK: - Stretchy Header
    
    func setupStretchyHeader(viewModel: ProfileStretchyHeaderViewModel) {
        
        let nib = UINib(nibName: "ProfileStretchyHeaderView", bundle: nil)
        let views = nib.instantiate(withOwner: self, options: nil)
        
        guard let headerView = views.first as? ProfileStretchyHeaderView else {
            assertionFailure()
            return
        }
        
        headerView.minimumContentHeight = navigationController?.navigationBar.frame.maxY ?? 0
        headerView.configure(with: viewModel)
        tableView.addSubview(headerView)
        
    }
    
    // MARK: - Refresh Control
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
        refreshControl.tintColor = .clear
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func beginRefreshing() {
        print("Refresh")
    }
    
    // MARK: - Call to Action
    
    var ctaGradientLayer: CAGradientLayer?
    
    func setupCallToAction() {
        
        if structureMapper.callToActionViewModel == nil {
            ctaToTableViewConstraint.isActive = false
            ctaContainerView.isHidden = true
            return
        }
        
        ctaContainerView.isHidden = false
        ctaToTableViewConstraint.isActive = true
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ctaGradientLayer?.frame = ctaContainerView.bounds
    }
    
    @IBAction func didTapCallToAction() {
        guard let callToActionViewModel = structureMapper.callToActionViewModel else {
            return
        }
        
        handleAction(action: callToActionViewModel.action)
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structureMapper.structure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = structureMapper.structure[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: item.itemType.nibName,
            for: indexPath
        )
        
        cell.backgroundColor = .clear
        
        if let configurableCell = cell as? ConfigurableCell {
            configurableCell.configure(with: item.object)
        }
        
        if let triggerCell = cell as? ProfileActionTrigger {
            triggerCell.actionHandler = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ProfileViewController: ProfileActionHandler {
    
    func handleAction(action: ProfileAction) {
        switch action {
        case .openURL(let url):
            print("[EVENT] Open URL (\(url))")
            
            let viewController = SFSafariViewController(url: url)
            present(viewController)
            
        case .openFilmShowChooser(let film):
            print("[EVENT] Open Film Showings (\(film.movieDetails.title))")
            
            let viewModel = ShowChooserViewController.ViewModel(
                siteID: String(OdeonStorage().userChosenCinema ?? 0),
                preload: preload,
                film: film
            )
            
            let viewController = ShowChooserViewController.create(viewModel: viewModel)
            navigationController?.push(viewController)
            
        case .openFilmDetails(let film):
            print("[EVENT] Open Film Details (\(film.title))")
            
            // TODO: Add loading and error handling
            // Refactor this to use PromiseKit
            
            FilmFetcher(film: film).fetch(completion: { result in
                
                switch result {
                case .failure(let error):
                    Squawk.shared.showError(error: error, protectedView: self.ctaButton)

                case .success(let filmDetails):
                    let mapper = FilmDetailsStructureMapper(film: filmDetails)
                    
                    let viewController = ProfileViewController.create(with: mapper)
                    viewController.preload = self.preload
                    viewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.push(viewController)

                }

            })
            
        case .openCastMember(let id):
            print("[EVENT] Open Cast Member (\(id))")
            
            let provider = MoyaProvider<MovieDBService>()
            provider.requestDecodePromise(.getCastDetails(personID: id), type: CastDetails.self).done { payload in
                print("[EVENT] Loading Cast Member Profile for \(payload.name)")
                
                let mapper = CastMemberStructureMapper(payload: payload)
                
                let viewController = ProfileViewController.create(with: mapper)
                viewController.preload = self.preload
    
                self.navigationController?.push(viewController)
            }.catch { error in
                print(error)
            }
            
        case .openAllCast(let film):
            print("[EVENT] Open All Cast (\(film.movieDetails.title))")
        }
    }
    
}
