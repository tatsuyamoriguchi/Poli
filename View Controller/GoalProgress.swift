//
//  GoalProgress.swift
//  PoliPoli
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
    

    
    func goalProgressCalc(goal: Goal, sender: UIViewController) -> Float {
        
        var goalProgressPercentage: Float = Float(totalNumberOfCompletedTasksSum(goal: goal)) / Float(totalNumberOfTasksSum(goal: goal))
    
        if goalProgressPercentage.isNaN == true {
            goalProgressPercentage = 0
            
        } else {}
 


        // goalProgressPercentage = (goalProgressPercentage * 10000).rounded() / 100
        // print("goalProgressPercentage = \(goalProgressPercentage)")
        return goalProgressPercentage
    }
    
    func goalProgressAchieved(percentage: Float) -> String {
        
        if percentage == 0.00 {
            progressMessage = "Nothing's been done yet???"
        } else if percentage > 0.00 && percentage <= 0.50 {
            progressMessage = "Let's do more!"
        } else if percentage >= 0.50 && percentage < 0.75 {
            progressMessage = "Good job, keep it up!"
            
        } else if percentage >= 0.75 && percentage < 0.90 {
            progressMessage = "You Are Amazing!"
            
        } else if percentage >= 0.90 && percentage < 1.00 {
           progressMessage = "You Are an Atomic Dog! Let's finish it up now!"
           
        }else if percentage == 1.00 {
            progressMessage = "Goal Completed!"
        } else {
            print("Something wrong on progress percentage")
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
        
        let alert = UIAlertController(title: "Congratulation!", message: "You Achieved \(progress)% of Goal, \"\(String(describing: goalTitle))!.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
        
    }
}
