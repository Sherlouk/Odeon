//
//  ResultsWrapperGenericResponse.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct ResultsWrapperGenericResponse<InnerData: Codable>: Codable {
    let results: [InnerData]
}
