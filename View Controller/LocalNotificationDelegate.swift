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

        // Conclusion is just show login or open app.
            
/*       //Displays TodaTasksTableVC without navigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let otherVC = sb.instantiateViewController(withIdentifier: "todayVC") as! TodaysTasksTableViewController
            appDelegate.window?.rootViewController = otherVC
*/
/*
 // Open GoalTableVC but username info is lost. makes Opening GoalTVC meaningless. Better to just display a list
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let otherVC = sb.instantiateViewController(withIdentifier: "rootNavigator") as! RootViewController
            appDelegate.window?.rootViewController = otherVC
*/
            
            /*
            // Just open app
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "rootNavigator") as! RootViewController
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "todayVC") as! TodaysTasksTableViewController
            navigationController.pushViewController(newViewController, animated: true)
*/
/*
            let navigationController = sb.instantiateViewController(withIdentifier: "rootNavigator") as! RootViewController
            
            let otherVC = sb.instantiateViewController(withIdentifier: "goalTVC") as! GoalTableViewController
            navigationController.popToViewController(otherVC, animated: true)
//            appDelegate.window?.rootViewController = otherVC
*/
            
            
/* error: rootViewController is LoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let sb = UIStoryboard(name: "Main", bundle: nil)

            let navigationController = appDelegate.window?.rootViewController as! RootViewController
            //let destinationViewController = navigationController.viewControllers[0] as! TodaysTasksTableViewController
            let destinationViewController = sb.instantiateViewController(withIdentifier: "todayVC") as! TodaysTasksTableViewController
            navigationController.popToViewController(destinationViewController, animated: true)
 */
            

            fetchTodayTasks()
            
            print("\nToday's Task To-Do tasks :")
            for task in tasks {
                print("\nTask To-Do: ")
                print(task.toDo ?? "Something went wrong to print task.toDo.\n")
            }
            print("\n")

 
        } else {
            
        }
        completionHandler()
        
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
