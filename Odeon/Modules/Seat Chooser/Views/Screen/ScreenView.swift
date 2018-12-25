//
//  ScreenView.swift
//  Odeon
//
//  Created by Sherlock, James on 24/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

class ScreenView: UIView {

    @IBInspectable var screenColour: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let percent = (bounds.width / 100) * 20
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(screenColour.cgColor)
            
            context.move(to: CGPoint(x: 0, y: 0)) // 0, 0
            context.addCurve(
                to: CGPoint(x: bounds.width, y: 0), // 1, 0
                control1: CGPoint(x: percent, y: bounds.height), // 0.2, 1
                control2: CGPoint(x: bounds.width - percent, y: bounds.height) // 0.8, 1
            )
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height)) // 1, 1
            context.addLine(to: CGPoint(x: 0, y: bounds.height)) // 0, 1
            context.closePath() // 0, 0
            
            context.fillPath()
        }
    }

}
