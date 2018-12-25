//
//  SeatChooserViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import Moya
import Squawk

class SeatChooserViewController: UIViewController, StoryboardLoadable {

    static var storyboardName: String {
        return "SeatChooser"
    }
    
    struct ViewModel {
        let performanceID: String
        let siteID: String
        let film: FilmFetcher.Film
    }
    
    struct SeatWrapper {
        let seat: SeatsData.Seat
        let section: BookingInit.Section
    }
    
    @IBOutlet var loadingIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var filmTitleLabel: UILabel!
    @IBOutlet var seatKeyIconImageViews: [UIImageView]!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var screenLabel: UILabel!
    @IBOutlet var cinemaLabel: UILabel!
    @IBOutlet var screeningInfoContainerView: UIView!
    
    @IBOutlet var ctaContainerView: UIView!
    @IBOutlet var ctaButton: UIButton!
    @IBOutlet var ctaIndicatorImageView: UIImageView!
    
    var viewModel: ViewModel!
    var bookingInit: BookingInit?
    
    var seatCount = 0
    var seatColumnCount = 0
    var allSeats: [SeatWrapper]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        setupCallToAction()
        setupHeader()
        setupKey()
        loadSeatData()
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
    
    // MARK: - Chair Key
    
    func setupKey() {
        seatKeyIconImageViews.forEach {
            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
            
            let tintColor = $0.tintColor
            $0.tintColor = tintColor
        }
    }
    
    // MARK: - Collection View
    
    func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Loading
    
    func loadSeatData() {
        screeningInfoContainerView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        let provider = MoyaProvider<OdeonService>()
        
        let request: OdeonService = .bookingInit(
            performanceID: viewModel.performanceID,
            siteID: viewModel.siteID
        )
        
        let promise = provider.requestDecodePromise(request, type: DataWrapperGenericResponse<BookingInit>.self)
        
        promise.done { data in
            self.bookingInit = data.data
            self.reloadData()
        }.catch { error in
            Squawk.shared.showError(error: error, protectedView: self.ctaButton)
        }
    }
    
    func reloadData() {
        guard let bookingInit = bookingInit else {
            return
        }
        
        // Update Screening Information
        screeningInfoContainerView.isHidden = false
        cinemaLabel.text = bookingInit.headerData.cinemaName
        screenLabel.text = bookingInit.headerData.screenName
        
        // Update Layout
        if let layout = collectionView.collectionViewLayout as? SeatChooserCollectionViewLayout {
            layout.bookingInit = bookingInit
        }
        
        // Remove the activity indicator
        loadingIndicatorView.stopAnimating()
        
        // Apply Changes
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
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
        let seatsSelected = collectionView.indexPathsForSelectedItems?.isEmpty == false
        
        if seatsSelected {
            ctaButton.setTitle("CHOOSE TICKETS", for: .normal)
            ctaButton.setTitleColor(UIColor(named: "Profile/PrimaryText"), for: .normal)
            ctaButton.isEnabled = true
        } else {
            ctaButton.setTitle("SELECT YOUR SEATS", for: .normal)
            ctaButton.setTitleColor(UIColor(named: "Profile/PrimaryText")?.withAlphaComponent(0.6), for: .normal)
            ctaButton.isEnabled = false
        }
        
        UIView.transition(
            with: ctaButton,
            duration: trueUnlessReduceMotionEnabled && !initial ? 0.3 : 0,
            options: [ .beginFromCurrentState ],
            animations: {
                self.ctaIndicatorImageView.alpha = seatsSelected ? 1 : 0
            },
            completion: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ctaGradientLayer?.frame = ctaContainerView.bounds
    }
    
    @IBAction func didTapCallToAction() {
        
        guard let selectedItems = collectionView.indexPathsForSelectedItems, !selectedItems.isEmpty else {
            Squawk.shared.showError(title: "Please select your seat first", protectedView: ctaButton)
            return
        }
        
        let seats = selectedItems.compactMap({ indexPath in
            bookingInit?.sections[indexPath.section].seatsString.seats[indexPath.item]
        })
        
        guard seats.count == selectedItems.count else {
            Squawk.shared.showError(title: "Something went wrong", protectedView: ctaButton)
            return
        }
        
        print("Let's go...")
    }
    
}

extension SeatChooserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bookingInit?.sections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingInit?.sections[section].seatsString.seats.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath)
        
        let section = bookingInit?.sections[indexPath.section]
        let seat = section?.seatsString.seats[indexPath.item]
        
        if let seatCell = cell as? SeatOptionCollectionViewCell, let section = section, let seat = seat {
            seatCell.configure(section: section, seat: seat)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCallToActionButtonText()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateCallToActionButtonText()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = bookingInit?.sections[indexPath.section]
        
        guard let seat = section?.seatsString.seats[indexPath.item] else {
            Squawk.shared.showError(title: "Something went wrong", protectedView: ctaButton)
            return false
        }
        
        
        guard seat.isBookable else {
            return false
        }
        
        return true
    }
    
}
