//
//  ProfileItemType.swift
//  Odeon
//
//  Created by Sherlock, James on 21/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

enum ProfileItemType: CaseIterable {
    
    case gallery
    case button
    case scroller
    case title
    case paragraph
    case review
    case rating
    case movieInformation
    
    var nibName: String {
        switch self {
        case .rating:
            return "ProfileRatingTableViewCell"
        case .review:
            return "ProfileReviewTableViewCell"
        case .paragraph:
            return "ProfileTextTableViewCell"
        case .gallery:
            return "ProfileGalleryContainerTableViewCell"
        case .button:
            return "ProfileButtonTableViewCell"
        case .scroller:
            return "HorizontalScrollerTableViewCell"
        case .title:
            return "ProfileTitleTableViewCell"
        case .movieInformation:
            return "MovieInformationTableViewCell"
        }
    }
    
}
