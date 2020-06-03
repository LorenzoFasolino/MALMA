//
//  AppIntent.swift
//  Homer
//
//  Created by Alessandro De Stefano on 03/06/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Foundation
import Intents

class AppIntent {
    
    class func allowSiri() {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .notDetermined,
                 .restricted,
                 .denied:
                print("Siri error.")
            case .authorized:
                print("Siri ok.")
            @unknown default:
                print("Unknown case")
            }
        }
    }
}
