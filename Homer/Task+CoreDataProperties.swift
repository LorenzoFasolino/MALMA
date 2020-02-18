//
//  Task+CoreDataProperties.swift
//  Homer
//
//  Created by Lorenzo Fasolino on 16/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var desc: String?
    @NSManaged public var doneNum: Int32
    @NSManaged public var ecoPoints: Int32
    @NSManaged public var savings: Float
    @NSManaged public var state: String?
    @NSManaged public var weekly: Bool
    @NSManaged public var priority: Int32
    @NSManaged public var id: Int32
    @NSManaged public var category: Category?
    @NSManaged public var goals: NSSet?
    
    
    func getIcon(_ desaturated: Bool) -> UIImage?{
           let iconName = category!.image
           if(desaturated){
               return UIImage(named: iconName!+"_desaturated")
           }
           else{
               return UIImage(named: iconName!)
           }
       }
    
    func check(){
       _ = PMDoneTask.newDoneTask(task: self)
        PMDoneTask.saveContext()
        self.doneNum += 1
        PMTask.saveContext()
        let user = PMUser.fetchUser()
        user.totSavings += self.savings
        user.totEcoPoints += self.ecoPoints
        PMUser.saveContext()
        
        let achievements = PMAchievement.fetchLocked()
        
        for achievement in achievements{
            
            if(achievement.checkDone()){
                print("premio ricevuto")
            }
            
        }
        
    }
    
    
    func unCheck(){
        
        var doneTasks:[DoneTask]
        
        if(weekly){
            doneTasks = PMDoneTask.fetchWeeklyTask(task: self)
        }else{
            doneTasks = PMDoneTask.fetchByTodayAndTask(task: self)
        }
        
        
        for doneTask in doneTasks{
            PMDoneTask.deleteDoneTask(doneTask: doneTask)
        }
        
        
        PMDoneTask.saveContext()
        
        self.doneNum -= 1
        PMTask.saveContext()
        
        let user = PMUser.fetchUser()
        user.totSavings -= self.savings
        user.totEcoPoints -= self.ecoPoints
        PMUser.saveContext()
        
        
        
    }
    
    func disable(){
        self.state = "disabled"
        PMTask.saveContext()
    }
    
    func enable(){
        self.state = "enabled"
        PMTask.saveContext()
    }
    
    func isChecked() -> Bool{
        if(weekly){
            print("weekly")
            let doneTasks = PMDoneTask.fetchWeeklyTask(task: self)
            
            if(doneTasks.count>0){
                return true
            }
            return false
            
            
        }else{
            
            let doneTasks = PMDoneTask.fetchByTodayAndTask(task: self)
            
            if(doneTasks.count>0){
                return true
            }
            return false
            
        }
        
        
    }
    
    func checkForPriority(){
        if(priority>0){
            
            let doneTasks = PMDoneTask.fetchDoneTaskOfPreviousDay(task: self)
            
            if doneTasks.count <= 0 {
                
                self.priority = 0
                PMTask.saveContext()
                
            }
            
            
        }
    }

}

// MARK: Generated accessors for goals
extension Task {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: Goal)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: Goal)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

}
