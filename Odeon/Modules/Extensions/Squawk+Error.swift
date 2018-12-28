//
//  Squawk+Error.swift
//  Odeon
//
//  Created by Sherlock, James on 25/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Squawk
import enum Moya.MoyaError
import class Moya.Response

extension Squawk {
    
    func showError(title: String, protectedView: UIView? = nil) {
        let viewHeight: CGFloat = {
            if let protectedView = protectedView, protectedView.superview?.isHidden != true {
                return protectedView.bounds.height
            }
            
            return 0
        }()
        
        show(config: Squawk.Configuration(
            text: title,
            backgroundColor: UIColor.red.withAlphaComponent(0.4),
            bottomPadding: viewHeight + 16
        ))
    }
    
    func showError(error: Error, protectedView: UIView? = nil) {
        print("[ERROR] \(error)")
        
        let message: String = {
            if let localizedError = error as? LocalizedError {
                return localizedError.errorDescription ?? localizedError.localizedDescription
            }
            
            return error.localizedDescription
        }()
        
        // Debugging snippet for identifying invalid JSON errors
//        if let moyaError = error as? MoyaError {
//            if let data = moyaError.response?.data {
//                print(String(data: data, encoding: .utf8))
//            }
//        }
        
        showError(title: message, protectedView: protectedView)
    }
    
}
