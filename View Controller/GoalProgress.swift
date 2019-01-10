//
//  GoalProgress.swift
//  Poli
//
//  Created by Tatsuya Moriguchi on 7/29/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class GoalProgress: NSNumber {
    //NSNumber
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")

    var totalNumberOfTasksSumCount: Int = 0
    var totalNumberOfCompletedTasksSumCount: Int = 0
    var totalNumberOfTasksToBeDoneCount: Int = 0
    var goalProgressPercentage: Float = 0.0
    var goalProgressPercentageInt: Int = 0
    var goal : Goal?
    var progressMessage: String?
    
    
    var statusString: String = ""
    var status: Bool = false
    
    func goalStatusAlert(dueDate: Date, isDone: Bool) -> (String, Bool) {
        
        let today = Date()
        let differenceOfDate = Calendar.current.dateComponents([.day, .hour], from: today, to: dueDate)
        var remainingHours = 24 + differenceOfDate.hour!
        var remainingDays: Int
        
        if isDone == false {
            if differenceOfDate.day! == 0 && remainingHours < 24 {

                let NSL_statusToday = String(format: NSLocalizedString("NSL_statusToday", value: "%d hours remaining!", comment: ""), remainingHours)
                statusString = NSL_statusToday
                status = true
                
            } else if differenceOfDate.day! < 0 {
                let NSL_statusPassed = NSLocalizedString("NSL_statusPassed", value: "Due Date has passed.", comment: "")
                statusString = NSL_statusPassed
                status = true
                
                
            } else if remainingHours > 24 || differenceOfDate.day! >= 1 {
                remainingHours = remainingHours - 23
                remainingDays = differenceOfDate.day! + 1
                
                let NSL_statusLeft = String(format: NSLocalizedString("NSL_statusLeft", value: "%d day(s) and %d hour{s} left.", comment: ""), remainingDays, remainingHours)
                statusString = NSL_statusLeft
                status = false
    
                
            } else {
                print("differenceOfDate exception error")
                let NSL_statusError = NSLocalizedString("NSL_statusError", value: "differenceOfDate  out of range error", comment: "")
                statusString = NSL_statusError
                status = false
              
            }
        
        } else {
            statusString = ""
            status = false
 
        }
        
        return (statusString, status)
        
    }
    
    
    
    
    
    func goalProgressCalc(goal: Goal, sender: UIViewController) -> Float {
        
        var goalProgressPercentage: Float = Float(totalNumberOfCompletedTasksSum(goal: goal)) / Float(totalNumberOfTasksSum(goal: goal))
        
        if goalProgressPercentage.isNaN == true {
            goalProgressPercentage = 0
            
        } else {}
        
        return goalProgressPercentage
    }
    
    func goalProgressAchieved(percentage: Float) -> String {
        
        if percentage == 0.00 {
            let NSL_progressNothing = NSLocalizedString("NSL_progressNothing", value: "Nothing's been done yet???", comment: "")
            progressMessage = NSL_progressNothing
        } else if percentage > 0.00 && percentage <= 0.50 {
            let NSL_progressMore = NSLocalizedString("NSL_progressMore", value: "Let's do more!", comment: "")
            progressMessage = NSL_progressMore
        } else if percentage >= 0.50 && percentage < 0.75 {
            let NSL_progressGood = NSLocalizedString("NSL_progressGood", value: "Good job, keep it up!", comment: "")
            progressMessage = NSL_progressGood
            
        } else if percentage >= 0.75 && percentage < 0.90 {
            let NSL_progressAmazing = NSLocalizedString("NSL_progressAmazing", value: "You Are Amazing!", comment: "")
            progressMessage = NSL_progressAmazing
            
        } else if percentage >= 0.90 && percentage < 1.00 {
            let NSL_progressAtomic = NSLocalizedString("NSL_progressAtomic", value: "You Are an Atomic Dog! Let's finish it up now!", comment: "")
            progressMessage = NSL_progressAtomic
            
        }else if percentage == 1.00 {
            let NSL_progressCompleted = NSLocalizedString("NSL_progressCompleted", value: "Goal Completed!", comment: "")
            progressMessage = NSL_progressCompleted
        } else {
            let NSL_progressError = NSLocalizedString("NSL_progressError", value: "Something wrong on progress percentage", comment: "")
            print(NSL_progressError)
        }
        
        return progressMessage!
    }
    
    func totalNumberOfTasksSum(goal: Goal) -> Int {
        
        totalNumberOfTasksSumCount = (goal.tasksAssigned?.count)!
        
        return totalNumberOfTasksSumCount
    }
    
    func totalNumberOfCompletedTasksSum(goal: Goal) -> Int {
        var count : Int = 0
        for task in goal.tasksAssigned! as! Set<Task> {
            if task.isDone == true {
                count += 1
            }
        }
        
        totalNumberOfCompletedTasksSumCount = count
        
        return totalNumberOfCompletedTasksSumCount
    }
    
    func totalNumberOfTasksToBeDoneSum() -> Int {
        totalNumberOfTasksToBeDoneCount = totalNumberOfTasksSumCount - totalNumberOfCompletedTasksSumCount
        return totalNumberOfTasksToBeDoneCount
    }
    // Not using for now
    func progressAchieved(progress: Int, sender: UIViewController, goalTitle: String) {
        let NSL_alertTitle_016 = NSLocalizedString("NSL_alertTitle_016", value: "Congratulation!", comment: "")
        let NSL_alertMessage_016 = String(format: NSLocalizedString("NSL_alertMessage_016", value: "You Achieved %d % of Goal, \"%@\"!.", comment: ""), progress, goalTitle)
        let alert = UIAlertController(title: NSL_alertTitle_016, message: NSL_alertMessage_016, preferredStyle: .alert)
        let NSL_oK = NSLocalizedString("NSL_oK", value: "OK", comment: "")
        alert.addAction(UIAlertAction(title: NSL_oK, style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
        
    }
}
