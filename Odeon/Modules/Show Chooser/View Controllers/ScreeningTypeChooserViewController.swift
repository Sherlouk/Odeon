//
//  ScreeningTypeChooserViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ScreeningTypeChooserViewController: UITableViewController, StoryboardLoadable {

    var options = [String]()
    var onSelection: ((String) -> Void)?
    
    static var storyboardName: String {
        return "ShowChooser"
    }
    
    static var viewControllerIdentifier: String? {
        return "ScreeningTypeChooser"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        preferredContentSize = CGSize(width: 200, height: tableView.contentSize.height)
        tableView.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Option", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?(options[indexPath.row])
        dismiss(animated: trueUnlessReduceMotionEnabled, completion: nil)
    }
    
}
