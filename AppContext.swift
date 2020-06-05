//
//  AppContext.swift
//  Homer
//
//  Created by Alessandro De Stefano on 05/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AppContext {
    static func getContext() -> NSManagedObjectContext{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
        
    }
}
