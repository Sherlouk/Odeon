//
//  UITableView+Extensions.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(nibName: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: nibName)
    }
    
}
