//
//  BridgeForTargets.swift
//  Homer
//
//  Created by Alessandro De Stefano on 04/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Foundation

class BridgeForTargets {
        
    static func getAllCategories() -> [Category] {
        PMCategory.fetchAllCategory()
    }
    
}
