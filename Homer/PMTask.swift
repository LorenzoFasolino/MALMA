//
//  PMUser.swift
//  Homer
//
//  Created by Lorenzo Fasolino on 14/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import CoreData
import Foundation

import UIKit

class PMTask {
    static let tableName = "Task"

    static func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        return appDelegate.persistentContainer.viewContext
    }

    static func newTask(id: Int32, desc: String, ecoPoint: Int32, savings: Float, state: String, weekly: Bool, categoty: Category) -> Task {
        let context = getContext()

        let task = NSEntityDescription.insertNewObject(forEntityName: tableName, into: context) as! Task

        task.id = id
        task.desc = desc
        task.doneNum = 0
        task.ecoPoints = ecoPoint
        task.savings = savings
        task.state = state
        task.weekly = weekly
        task.category = categoty
        task.priority = 0

        task.goals = NSSet()

        return task
    }

    static func fetchAllTask() -> [Task] {
        var task: [Task] = []

        let context = getContext()

        let fetchRequest = NSFetchRequest<Task>(entityName: tableName)

        do {
            try task = context.fetch(fetchRequest)

        } catch let error as NSError {
            print("Errore in fetch \(error.code)")
        }

        return task
    }

    static func fetchUnselectedTask(_ withPriority: Bool = false) -> [Task] {
        var tasks: [Task] = []

        let context = getContext()

        let fetchRequest = NSFetchRequest<Task>(entityName: tableName)
        fetchRequest.predicate = NSPredicate(format: "state = 'enabled'")

        do {
            try tasks = context.fetch(fetchRequest)

        } catch let error as NSError {
            print("Errore in fetch \(error.code)")
        }

        var arrayOfId: [Int32]

        if withPriority {
            if let lastOrderDate = UserDefaults.standard.object(forKey: "lastOrderDate") as? Date {
                if !Calendar.current.isDateInToday(lastOrderDate) {
                    tasks = OrderArray.orderWithRandomPriorityPoll(tasks)
                    arrayOfId = tasks.map {
                        task in task.id
                    }
                    UserDefaults.standard.set(arrayOfId, forKey: "arrayOfId")
                    UserDefaults.standard.set(Date(), forKey: "lastOrderDate")
                } else {
                    if let arrayOfId = UserDefaults.standard.array(forKey: "arrayOfId") as? [Int32] {
                        if let orderedTasks = OrderArray.orderWithArrayOfId(arrayOfId: arrayOfId, arrayOfTasks: tasks) {
                            tasks = orderedTasks
                        }
                    }
                }
            }
        }
        return tasks.filter { !$0.isChecked() }
    }

    static func fetchById(id: Int32) -> [Task] {
        var task: [Task] = []

        let context = getContext()

        let fetchRequest = NSFetchRequest<Task>(entityName: tableName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)

        do {
            try task = context.fetch(fetchRequest)

        } catch let error as NSError {
            print("Errore in fetch \(error.code)")
        }

        return task
    }

    static func saveContext() {
        let context = getContext()

        do {
            try context.save()

        } catch let error as NSError {
            print("Errore in fetch \(error.code)")
        }
    }

    static func deleteTask(task: Task) {
        let context = getContext()
        context.delete(task)
    }
}
