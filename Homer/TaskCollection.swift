//
//  TaskCollection.swift
//  Homer
//
//  Created by Marco Mannara on 13/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit
import Foundation

class TaskCollection {
    private var tasks : [Task]
    
    init(){
        tasks = [Task]()
    }
    
    func add(_ task: Task){
        tasks.append(task)
    }
    
    func remove(_ at: Int){
        tasks.remove(at: at)
    }
    
    func swap(_ from: Int, _ to: Int){
    }
}

struct Task {
    let savings : Float
    let description : String
    let ecoPoints : Int
    let category : UIImageView
}
