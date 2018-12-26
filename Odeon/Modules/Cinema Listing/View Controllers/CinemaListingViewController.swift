//
//  CinemaListingViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 26/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class CinemaListingViewController: UIViewController, StoryboardLoadable {
    
    static var storyboardName: String {
        return "CinemaListing"
    }
    
    var cinemas: [Cinema]!
    var onCinemaChange: (() -> Void)?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var ctaContainerView: UIView!
    @IBOutlet var ctaButton: UIButton!
    @IBOutlet var ctaIndicatorImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        let currentCinemaID = OdeonStorage().userChosenCinema
        if let index = cinemas.firstIndex(where: { $0.id == currentCinemaID }) {
            tableView.selectRow(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .none)
        }
        
        setupCallToAction()
    }
    
    @IBAction func didTapDismiss() {
        dismiss(animated: trueUnlessReduceMotionEnabled, completion: nil)
    }
    
    // MARK: - Navigation
    
    func setupNavigationBar() {
        
        guard let controller = navigationController as? TransparentNavigationViewController else {
            return
        }
        
        navigationItem.leftBarButtonItem = controller.backButton
        
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
        
        let cinemaSelected = tableView.indexPathForSelectedRow != nil
        
        if cinemaSelected {
            ctaButton.setTitle("CONFIRM", for: .normal)
            ctaButton.setTitleColor(UIColor(named: "Profile/PrimaryText"), for: .normal)
            ctaButton.isEnabled = true
        } else {
            ctaButton.setTitle("SELECT YOUR CINEMA", for: .normal)
            ctaButton.setTitleColor(UIColor(named: "Profile/PrimaryText")?.withAlphaComponent(0.6), for: .normal)
            ctaButton.isEnabled = false
        }
        
        UIView.transition(
            with: ctaButton,
            duration: trueUnlessReduceMotionEnabled && !initial ? 0.3 : 0,
            options: [ .beginFromCurrentState ],
            animations: {
                self.ctaIndicatorImageView.alpha = cinemaSelected ? 1 : 0
            },
            completion: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ctaGradientLayer?.frame = ctaContainerView.bounds
    }
    
    @IBAction func didTapCallToAction() {
        guard let selectedRow = tableView.indexPathForSelectedRow else {
            return
        }
        
        let cinema = cinemas[selectedRow.item]
        OdeonStorage().userChosenCinema = cinema.id
        onCinemaChange?()
        dismiss(animated: trueUnlessReduceMotionEnabled, completion: nil)
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension CinemaListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cinemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaListing", for: indexPath) as? CinemaListingTableViewCell else {
            fatalError()
        }
        
        let cinema = cinemas[indexPath.item]
        cell.configure(with: cinema)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCallToActionButtonText()
    }
    
}
