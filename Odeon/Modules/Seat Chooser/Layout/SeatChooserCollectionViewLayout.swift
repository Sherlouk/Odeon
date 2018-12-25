//
//  SeatChooserCollectionViewLayout.swift
//  Odeon
//
//  Created by Sherlock, James on 25/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class SeatChooserCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Cache
    
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat = 0
    
    private var itemCache = [UICollectionViewLayoutAttributes]()
    
    // MARK: - Configuration
    
    @IBInspectable var rowSpacing: CGFloat = 14
    @IBInspectable var seatSpacing: CGFloat = 5
    
    // MARK: - Data
    
    var columnCount: CGFloat = 0
    var rowCount: CGFloat = 0
    var bookingInit: BookingInit? {
        didSet {
            if let seats = bookingInit?.sections.flatMap({ $0.seatsString.seats }) {
                
                var maxWidth = 0
                var maxHeight = 0
                var seatWidth = 0
                
                for seat in seats {
                    let maxX = seat.x + seat.width
                    
                    if maxX > maxWidth {
                        maxWidth = maxX
                        seatWidth = seat.width
                    }
                    
                    let maxY = seat.y + seat.height
                    
                    if maxY > maxHeight {
                        maxHeight = maxY
                    }
                }
                
                columnCount = (CGFloat(maxWidth) / CGFloat(seatWidth)) - 1
                rowCount = CGFloat(maxHeight) / CGFloat(seatWidth)
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
        let totalHeight = rowCount * (seatWidth + rowSpacing)
        let topPadding = collectionView.bounds.height - totalHeight
        
        print("[SEAT CHOOSER] Setting seat width to \(seatWidth)")
        
        for (sectionIndex, section) in bookingInit.sections.enumerated() {
            for (seatIndex, seat) in section.seatsString.seats.enumerated() {
                
                let indexPath = IndexPath(item: seatIndex, section: sectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let column = seat.x / seat.width
                let row = seat.y / seat.height
                
                attributes.frame = CGRect(
                    x: CGFloat(column - 1) * (seatWidth + seatSpacing),
                    y: topPadding + (CGFloat(row - 1) * (seatWidth + rowSpacing)),
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
