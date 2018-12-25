//
//  SeatChooserViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import Moya

class SeatChooserViewController: UIViewController, StoryboardLoadable {

    static var storyboardName: String {
        return "SeatChooser"
    }
    
    struct ViewModel {
        let performanceID: String
        let siteID: String
    }
    
    struct SeatWrapper {
        let seat: BookingInit.Section.SeatsData.Seat
        let section: BookingInit.Section
    }
    
    @IBOutlet var collectionView: UICollectionView!
    var viewModel: ViewModel!
    var bookingInit: BookingInit?
    
    var seatCount = 0
    var seatColumnCount = 0
    var allSeats: [SeatWrapper]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        loadSeatData()
    }
    
    // MARK: - Navigation
    
    func setupNavigationBar() {
        
        guard let controller = navigationController as? TransparentNavigationViewController else {
            return
        }
        
        navigationItem.leftBarButtonItem = controller.backButton
        
    }
    
    // MARK: - Collection View
    
    func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Loading
    
    func loadSeatData() {
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
            print(error)
        }
    }
    
    func reloadData() {
        guard let bookingInit = bookingInit else {
            return
        }
        
        // Update Layout
        if let layout = collectionView.collectionViewLayout as? SeatChooserCollectionViewLayout {
            layout.bookingInit = bookingInit
        }
        
        // Apply Changes
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
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
        print("[SEAT CHOOSER] Selected: \(indexPath)")
        print(collectionView.indexPathsForSelectedItems ?? [])
        
//        if let cell = collectionView.cellForItem(at: indexPath) as? SeatOptionCollectionViewCell {
//            cell.seatImageView.tintColor = UIColor.red
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("[SEAT CHOOSER] Deselected: \(indexPath)")
        print(collectionView.indexPathsForSelectedItems ?? [])        
//        if let cell = collectionView.cellForItem(at: indexPath) as? SeatOptionCollectionViewCell {
//            cell.seatImageView.tintColor = UIColor.white
//        }
    }
    
}

class SeatChooserCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Cache
    
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat = 0
    
    private var itemCache = [UICollectionViewLayoutAttributes]()
    
    // MARK: - Configuration
    
    @IBInspectable var rowSpacing: CGFloat = 10
    @IBInspectable var seatSpacing: CGFloat = 5
    
    // MARK: - Data
    
    var columnCount: CGFloat = 0
    var bookingInit: BookingInit? {
        didSet {
            if let seats = bookingInit?.sections.flatMap({ $0.seatsString.seats }) {
                
                var maxWidth = 0
                var seatWidth = 0
                
                for seat in seats {
                    let maxX = seat.x + seat.width
                    
                    if maxX > maxWidth {
                        maxWidth = maxX
                        seatWidth = seat.width
                    }
                }
                
                columnCount = (CGFloat(maxWidth) / CGFloat(seatWidth)) - 1
            }
        }
    }
    
    // MARK: - Content Size
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Layout Attributes
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemCache.filter({ $0.frame.intersects(rect) })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemCache.first(where: { $0.indexPath == indexPath })
    }
    
    // MARK: - Invalidate Layout
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldWidth = collectionView?.bounds.width {
            return oldWidth != newBounds.width
        }
        
        return false
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        itemCache = []
        contentWidth = 0
        contentHeight = 0
    }
    
    // MARK: - Prepare
    
    override func prepare() {
        guard let collectionView = collectionView, let bookingInit = bookingInit else {
            return
        }
        
        let horizontalInset = collectionView.contentInset.left + collectionView.contentInset.right
        let seatSpacingTotal = (columnCount - 1) * seatSpacing
        let usableWidth = collectionView.bounds.width - horizontalInset - seatSpacingTotal
        let seatWidth = usableWidth / columnCount
        
        print("[SEAT CHOOSER] Setting seat width to \(seatWidth)")
        
        for (sectionIndex, section) in bookingInit.sections.enumerated() {
            for (seatIndex, seat) in section.seatsString.seats.enumerated() {
                
                let indexPath = IndexPath(item: seatIndex, section: sectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let column = seat.x / seat.width
                let row = seat.y / seat.height
                
                attributes.frame = CGRect(
                    x: CGFloat(column - 1) * (seatWidth + seatSpacing),
                    y: CGFloat(row - 1) * (seatWidth + rowSpacing),
                    width: seatWidth,
                    height: seatWidth
                )
                
                contentWidth = max(contentWidth, attributes.frame.maxX)
                contentHeight = max(contentHeight, attributes.frame.maxY)
                
                itemCache.append(attributes)
                
            }
        }
    }
    
}
