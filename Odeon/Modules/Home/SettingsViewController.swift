//
//  SettingsViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, StoryboardLoadable {

    var preload: OdeonPreloadFetcher.Preload!
    @IBOutlet var currentCinemaLabel: UILabel!
    
    static var storyboardName: String {
        return "Home"
    }
    
    static var viewControllerIdentifier: String? {
        return "Settings"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCinemaLabel()
    }
    
    func reloadCinemaLabel() {
        let currentCinemaID = OdeonStorage().userChosenCinema
        let currentCinema = preload.cinemas.first(where: { $0.id == currentCinemaID })
        currentCinemaLabel.text = "Current: \(currentCinema?.name ?? "Unselected")"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.section == 0 {
            let currentCountry = OdeonBaseURL.current
            
            switch indexPath.item {
            case 0: cell.accessoryType = currentCountry == .UK ? .checkmark : .none
            case 1: cell.accessoryType = currentCountry == .ireland ? .checkmark : .none
            default: break
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "Profile/SecondaryText")
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        header.backgroundView?.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0), (0, 1): // Choose your Country
            updateCountrySelection(index: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: false)
            return
            
        case (1, 0): // Choose your Cinema
            let viewController = CinemaListingViewController.create()
            viewController.cinemas = preload.cinemas
            viewController.onCinemaChange = {
                self.reloadCinemaLabel()
            }
            
            present(viewController, animated: trueUnlessReduceMotionEnabled, completion: nil)
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func updateCountrySelection(index: Int) {
        let ukCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0))
        let niCell = tableView.cellForRow(at: IndexPath(item: 1, section: 0))
        
        ukCell?.accessoryType = index == 0 ? .checkmark : .none
        niCell?.accessoryType = index == 1 ? .checkmark : .none
        
        let country: OdeonBaseURL = index == 0 ? .UK : .ireland
        OdeonStorage().userChosenCountry = country.rawValue
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
