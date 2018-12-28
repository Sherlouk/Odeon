//
//  ScrollerImageViewModel.swift
//  Odeon
//
//  Created by Sherlock, James on 23/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct ScrollerImageViewModel {
    
    let title: String
    let imageURL: URL?
    let aspectRatio: AspectRatio
    let tapAction: ProfileAction?
    
    let secondaryText: String?
    let halfRating: Int?
    let certificate: Certificate?
    
}
