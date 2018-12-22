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
    
    @IBOutlet var tableView: UITableView!
    var structureMapper: TemporaryStructureMapper!
    
    var stretchyHeader: ProfileStretchyHeaderView?
    
    // MARK: - Create
    
    class func create(with mapper: TemporaryStructureMapper) -> ProfileViewController {
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
        
        let headerViewModel = ProfileStretchyHeaderViewModel(
            title: structureMapper.film.movieDetails.original_title,
            description: "(0000)",
            imageURL: URL(string: "https://image.tmdb.org/t/p/original/\(structureMapper.film.movieDetails.backdrop_path ?? "")")!,
            tagTitle: structureMapper.film.movieDetails.genres.first?.name ?? "UNKNOWN"
        )
        
        setupStretchyHeader(viewModel: headerViewModel)
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
        
        let item = UIBarButtonItem(title: "Test", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = item
        
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structureMapper.struture.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = structureMapper.struture[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: item.itemType.nibName,
            for: indexPath
        )
        
        cell.backgroundColor = .clear
        
        if let configurableCell = cell as? ConfigurableCell {
            configurableCell.configure(with: item.object)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
