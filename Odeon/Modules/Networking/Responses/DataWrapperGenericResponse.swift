//
//  DataWrapperGenericResponse.swift
//  Odeon
//
//  Created by Sherlock, James on 16/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation

struct DataWrapperGenericResponse<InnerData: Codable>: Codable {
    let data: InnerData
}
