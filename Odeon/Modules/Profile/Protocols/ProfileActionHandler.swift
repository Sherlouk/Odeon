//
//  ProfileActionHandler.swift
//  Odeon
//
//  Created by Sherlock, James on 23/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

protocol ProfileActionHandler: class {
    func handleAction(action: ProfileAction)
}

enum ProfileAction {
    case openURL(url: URL)
}

protocol ProfileActionTrigger: class {
    var actionHandler: ProfileActionHandler? { get set }
}
