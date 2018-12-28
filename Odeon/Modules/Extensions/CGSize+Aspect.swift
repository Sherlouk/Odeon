//
//  CGSize+Aspect.swift
//  Odeon
//
//  Created by Sherlock, James on 28/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

enum AspectRatio {
    case poster
    case headshot
    
    var size: CGSize {
        switch self {
        case .poster: return CGSize(width: 11, height: 16)
        case .headshot: return CGSize(width: 2, height: 2.5)
        }
    }
}

extension CGSize {
    
    init(width: CGFloat, aspectRatio: AspectRatio) {
        let aspectRatioDecimal = aspectRatio.size.asAspectRatioDecimal
        self.init(width: width, height: aspectRatioDecimal * width)
    }
    
    init(height: CGFloat, aspectRatio: AspectRatio) {
        let aspectRatioDecimal = aspectRatio.size.asAspectRatioDecimal
        self.init(width: height / aspectRatioDecimal, height: height)
    }
    
    var asAspectRatioDecimal: CGFloat {
        return height / width
    }
    
}
