//
//  GoalDueDateViewController.swift
//  Poli
//
//  Created by Tatsuya Moriguchi on 8/1/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit

class GoalDueDateViewController: UIViewController {

    
    @IBOutlet weak var goalDueDatePicker: UIDatePicker!
    @IBAction func cancelToRoot(_ sender: UIButton) {
        navigationController!.popToRootViewController(animated: true)
    }
    
    var segueName: String?
    var goalTitle: String = ""
    var goalDescription: String = ""
    var goal: Goal!
    
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To update goal, show the goal title
        if segueName == "updateGoal" {
            goalDueDatePicker.date = goal.goalDueDate! as Date
        }
        
        datePicker = UIDatePicker()
        let NSL_nextButton_03 = NSLocalizedString("NSL_nextButton_03", value: "Next", comment: "")
        let nextButton = UIBarButtonItem(title: NSL_nextButton_03, style: .done, target: self, action: #selector(nextGoal))
        self.navigationItem.rightBarButtonItem = nextButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nextGoal() {
        
        self.performSegue(withIdentifier: "toGoalReward", sender: self)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toGoalReward" {
            let destVC  = segue.destination as! GoalRewardViewController
            destVC.segueName = segueName
            destVC.goal = goal
            destVC.goalTitle = goalTitle
            destVC.goalDescription = goalDescription
            
            let dueDate = goalDueDatePicker.date as Date
            let startOfDate = Calendar.current.startOfDay(for: dueDate)
            destVC.goalDueDate = startOfDate
            print(startOfDate)
        }
    }
    

}
