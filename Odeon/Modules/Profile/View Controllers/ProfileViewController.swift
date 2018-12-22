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
    
    // MARK: - Create
    
    class func create() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as? ProfileViewController
        
        assert(viewController != nil, "Initial View Controller Not Set or Invalid Cast")
        
        return viewController!
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileItemType.allCases.forEach({
            tableView.register(nibName: $0.nibName)
        })
        
        tableView.dataSource = self
        
        let item = UIBarButtonItem(title: "Test", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = item
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        // Allows the table view to extend beneath status bar and translucent navigation bar
        tableView.contentInset = UIEdgeInsets(
            top: -view.safeAreaInsets.top,
            left: 0,
            bottom: 0,
            right: 0
        )
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
