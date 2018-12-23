//
//  HorizontalScrollerTableViewCell.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class HorizontalScrollerTableViewCell: UITableViewCell, ConfigurableCell {

    @IBOutlet var collectionView: UICollectionView!
    var viewModels: [ScrollerImageViewModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "ScrollerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScrollerImageCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func configure(with object: Any?) {
        
        guard let viewModels = object as? [ScrollerImageViewModel] else {
            assertionFailure("Object could not be cast to correct view model")
            return
        }
        
        self.viewModels = viewModels
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Cell \(indexPath.item)")
    }
    
}
