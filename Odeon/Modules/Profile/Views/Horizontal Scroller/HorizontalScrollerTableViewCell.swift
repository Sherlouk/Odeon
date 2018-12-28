//
//  HorizontalScrollerTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class HorizontalScrollerTableViewCell: UITableViewCell, ConfigurableCell, ProfileActionTrigger {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    
    var viewModels: [ScrollerImageViewModel]?
    var actionHandler: ProfileActionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "ScrollerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScrollerImageCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let startPoint = CGPoint(x: -collectionView.contentInset.left, y: 0)
        collectionView.setContentOffset(startPoint, animated: false)
    }
    
    func configure(with object: Any?) {
        
        guard let viewModel = object as? HorizontalScrollerViewModel else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        guard let contents = viewModel.contents as? [ScrollerImageViewModel] else {
            assertionFailure("Could not cast contents to known view model")
            return
        }
        
        self.viewModels = contents
        heightConstraint.constant = viewModel.itemSize.height
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = viewModel.itemSize
        }
        
        collectionView.reloadData()
    }
    
}

extension HorizontalScrollerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollerImageCollectionViewCell", for: indexPath) as! ScrollerImageCollectionViewCell
        cell.configure(with: viewModels?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel = viewModels?[indexPath.item], let action = viewModel.tapAction else {
            return
        }
        
        actionHandler?.handleAction(action: action)
        
    }
    
}
