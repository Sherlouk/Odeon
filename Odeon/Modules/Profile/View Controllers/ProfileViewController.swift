//
//  ProfileViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet var ctaButton: UIButton!
    @IBOutlet var ctaContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var structureMapper: ProfileStructureMapper!
    var stretchyHeader: ProfileStretchyHeaderView?
    var preload: OdeonPreloadFetcher.Preload!
    var film: FilmFetcher.Film! // TEMP
    
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
        tableView.contentInsetAdjustmentBehavior = .never
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
        
        navigationItem.leftBarButtonItem = controller.backButton
        navigationItem.rightBarButtonItem = controller.shareButton
        
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
        let viewModel = ShowChooserViewController.ViewModel(
            siteID: "27", // TEMPORARY
            preload: preload,
            film: film
        )
        
        let viewController = ShowChooserViewController.create(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: trueUnlessReduceMotionEnabled)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
            print(url)
        }
    }
    
}
