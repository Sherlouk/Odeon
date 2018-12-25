//
//  Squawk+Error.swift
//  Odeon
//
//  Created by Sherlock, James on 25/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Squawk

extension Squawk {
    
    func showError(title: String, protectedView: UIView? = nil) {
        show(config: Squawk.Configuration(
            text: title,
            backgroundColor: UIColor.red.withAlphaComponent(0.4),
            bottomPadding: (protectedView?.bounds.height ?? 0) + 16
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
        
        showError(title: message, protectedView: protectedView)
    }
    
}
