//
//  LocalNotificationDelegate.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/19/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData
import UIKit

class LocalNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    //var context: NSManagedObjectContext!
    //let selectedGoal: Goal?
    var tasks = [Task]()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "yes" {
            
            fetchTodayTasks()
            print("\nToday's Task To-Do tasks :")

            for task in tasks {
                print("\nTask To-Do: ")
                print(task.toDo ?? "Something went wrong to print task.toDo.\n")
            }
            print("\n")

            
        } else {
            
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    
    func fetchTodayTasks() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        //var taskDate = Task.date
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        //        let todayPredicate = NSPredicate(format: "date >= %@ AND date < %@", dateFrom as CVarArg, dateTo! as CVarArg)
        let todayPredicate = NSPredicate(format: "date < %@", dateTo! as CVarArg)
        
        let donePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [todayPredicate, donePredicate])
        
        fetchRequest.predicate = andPredicate
        
        
        // Declare sort descriptor
        let sortByGoalAssigned = NSSortDescriptor(key: #keyPath(Task.goalAssigned), ascending: true)
        let sortByToDo = NSSortDescriptor(key: #keyPath(Task.toDo), ascending: true)
        
        //        let sortByDone = NSSortDescriptor(key: #keyPath(Task.isDone), ascending: true)
        let sortByDate = NSSortDescriptor(key: #keyPath(Task.date), ascending: true)
        
        // Sort fetchRequest array data
        fetchRequest.sortDescriptors = [sortByGoalAssigned, sortByDate, sortByToDo]
        
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch {
            print(error)
        }
        
        
    }
        
}
