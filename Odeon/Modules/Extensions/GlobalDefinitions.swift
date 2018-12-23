//
//  GlobalDefinitions.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import UIKit

typealias VoidClosure = () -> Void

func assertNotNil(_ condition: @autoclosure () -> Optional<Any>, file: StaticString = #file, line: UInt = #line) {
    
    if case .none = condition() {
        assertionFailure(file: file, line: line)
    }
    
}

var trueUnlessReduceMotionEnabled: Bool {
    if UIAccessibility.isReduceMotionEnabled {
        return false
    }
    
    return true
}
