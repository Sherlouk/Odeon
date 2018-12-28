//
//  MovieInformationTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import Kingfisher

class MovieInformationTableViewCell: UITableViewCell, ConfigurableCell, ProfileActionTrigger {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var certificateImageView: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var runningTimeLabel: UILabel!
    
    var certificate: Certificate?
    weak var actionHandler: ProfileActionHandler?
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? MovieInformationViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        runningTimeLabel.text = runningTime(minutes: viewModel.runningTime)
        languageLabel.text = viewModel.language
        releaseDateLabel.text = releaseDate(date: viewModel.releaseDate)
        certificateImageView.image = viewModel.certificate.image
        
        if let director = viewModel.director {
            directorLabel.text = director
            directorLabel.superview?.isHidden = false
        } else {
            directorLabel.superview?.isHidden = true
        }
        
        posterImageView.kf.setImage(with: viewModel.posterImageURL)
        
        self.certificate = viewModel.certificate
        
    }
    
    func runningTime(minutes: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: Double(minutes * 60)) ?? "Unknown"
    }
    
    func releaseDate(date: Date) -> String {
        if date < Date() { // Before now
            return "Out Now"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        return formatter.string(from: date)
    }
    
    @IBAction func didTapCertificate() {
        
        guard let url = certificate?.infoURL else {
            assertionFailure("Failed to assign certificate to Movie Information")
            return
        }
        
        actionHandler?.handleAction(action: .openURL(url: url))
        
    }
    
}
