//
//  TimeSlotChooserViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TimeSlotChooserViewController: UIViewController, IndicatorInfoProvider {

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        
        return formatter
    }()
    
    @IBOutlet var collectionView: UICollectionView!
    var onPerformanceChange: ((Performance?) -> Void)?
    
    static func create(day: FilmTimes.Day) -> TimeSlotChooserViewController {
        let storyboard = UIStoryboard(name: "ShowChooser", bundle: nil)
        let baseViewController = storyboard.instantiateViewController(withIdentifier: "TimeSlotChooser")
        
        guard let viewController = baseViewController as? TimeSlotChooserViewController else {
            fatalError()
        }
        
        viewController.day = day
        
        return viewController
    }
    
    var day: FilmTimes.Day!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: TimeSlotChooserViewController.dateFormatter.string(from: day.date.date))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension TimeSlotChooserViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day.performances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Performance", for: indexPath) as! PerformanceOptionCollectionViewCell
        let performance = day.performances[indexPath.item]
        cell.timeLabel.text = performance.time
        cell.descriptionLabel.text = performance.screenName
        cell.isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) == true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let usableWidth: CGFloat = {
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
                return 0
            }
            
            let insets = layout.sectionInset.left + layout.sectionInset.right
            let interitemSpacing = layout.minimumInteritemSpacing
            
            return collectionView.bounds.width - interitemSpacing - insets
        }()
        
        return CGSize(width: usableWidth / 2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let performance = day.performances[indexPath.item]
        onPerformanceChange?(performance)
    }
    
}
