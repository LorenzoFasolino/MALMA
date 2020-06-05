//
//  Populator.swift
//  Homer
//
//  Created by Lorenzo Fasolino on 14/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import Foundation
import GreenCore

class Populator {
    static func populateDB() {
        // @discardableResult
        PMUser.newUser(appContext: AppContext.getContext())

        let categories = jsonRead(fileName: "categories")

//        print(categories[0]["name"]!)

        for category in categories {
            // @discardableResult
            PMCategory.newCategory(imageName: category["image"] as! String, name: category["name"] as! String, appContext: AppContext.getContext())
        }

        let tasks = jsonRead(fileName: "task")

        for task in tasks {
            print("category = \(task["category"] as! String)")

            let category = PMCategory.fetchByName(name: task["category"] as! String, appContext: AppContext.getContext())

            let id = Int32(task["id"] as! String)
            let desc = task["desc"] as! String
            let ecoP = Int32(task["ecoPoints"] as! String)
            let savings = Float(task["savings"] as! String)
            let weekly = Bool(task["weekly"] as! String)

            let t = PMTask.newTask(id: id!, desc: desc, ecoPoint: ecoP!, savings: savings!, state: "enabled", weekly: weekly!, categoty: category[0], appContext: AppContext.getContext())

            category[0].addTask(task: t)
        }

        let achievements = jsonRead(fileName: "achievement")

        for achievement in achievements {
            let image = achievement["image"] as! String
            let name = achievement["name"] as! String
            let desc = achievement["desc"] as! String

            // @discardableResult
            PMAchievement.newAchievement(imageName: image, name: name, desc: desc, appContext: AppContext.getContext())
        }

        let goals = jsonRead(fileName: "goal")

        for goal in goals {
            let category = goal["category"] as! String
            let achievementName = goal["achievement"] as! String

            let achievement = PMAchievement.fetchByName(name: achievementName, appContext: AppContext.getContext())

            let goalNum = Int32(goal["goal"] as! String)
            let below = Bool(goal["below"] as! String)

            // @discardableResult
            PMGoal.newGoal(category: category, achivement: achievement[0], goalNum: goalNum!, below: below!, appContext: AppContext.getContext())
        }

        PMTask.saveContext(appContext: AppContext.getContext())
    }

    static func jsonRead(fileName: String) -> [[String: Any]] {
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        var json: [[String: Any]] = [["": ""]]
        do {
            let jsonData = try Data(contentsOf: url)
            json = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
        } catch {
            print(error)
        }

        return json
    }
}
