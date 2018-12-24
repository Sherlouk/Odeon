//
//  DayChooserViewController.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ContextMenu

class DayChooserViewController: ButtonBarPagerTabStripViewController {
    
    var data = [FilmTimes]() {
        didSet {
            reloadData()
        }
    }
    
    @IBOutlet var currentScreeningTypeLabel: UILabel!
    var currentAttribute: String?
    var onPerformanceChange: ((Performance?) -> Void)?
    
    override func viewDidLoad() {
        updateSettings()
        super.viewDidLoad()
    }
    
    func updateSettings() {
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarHeight = 1
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarMinimumInteritemSpacing = 30
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        changeCurrentIndexProgressive = { (oldCell, newCell, progressPercentage, changeCurrentIndex, animated) in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = UIColor.white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    func reloadData() {
        currentAttribute = currentAttribute ?? data.first?.attribute
        currentScreeningTypeLabel.text = currentAttribute
        reloadPagerTabStripView()
    }
    
    @IBAction func didTapChangeScreeningType(_ sender: UIButton) {
        let viewController = ScreeningTypeChooserViewController.create()
        viewController.options = data.map({ $0.attribute })
        viewController.onSelection = { attribute in
            self.currentAttribute = attribute
            self.onPerformanceChange?(nil)
            self.reloadData()
        }
        
        ContextMenu.shared.show(
            sourceViewController: self,
            viewController: viewController,
            options: ContextMenu.Options(
                containerStyle: ContextMenu.ContainerStyle(
                    backgroundColor: UIColor(red: 41/255.0, green: 45/255.0, blue: 53/255.0, alpha: 1)
                ),
                menuStyle: .minimal,
                hapticsStyle: .medium
            ),
            sourceView: currentScreeningTypeLabel,
            delegate: nil
        )
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        guard let attributeData = data.first(where: { $0.attribute == currentAttribute }) else {
            return [TimesLoadingViewController.create()]
        }
        
        var builder = [UIViewController]()
        
        for day in attributeData.days {
            let viewController = TimeSlotChooserViewController.create(day: day)
            viewController.onPerformanceChange = onPerformanceChange
            
            builder.append(viewController)
        }
        
        return builder
    }

}
