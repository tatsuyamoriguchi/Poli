//
//  GoalTitleViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/1/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit

class GoalTitleViewController: UIViewController, UITextFieldDelegate {
    
    var segueName: String?
    var goal: Goal!
    

    @IBOutlet weak var goalTitleTextField: UITextField!
    @IBOutlet weak var goalTitleTextView: UITextView!
    
    @IBAction func cancelToRoot(_ sender: Any) {
        navigationController!.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To update goal, show the goal title
        if segueName == "updateGoal" {
            goalTitleTextField.text = goal.goalTitle
        }

        goalTitleTextField.delegate = self
        
        
        let NSL_nextButton_01 = NSLocalizedString("NSL_nextButton_01", value: "Next", comment: "")
        let nextButton = UIBarButtonItem(title: NSL_nextButton_01, style: .done, target: self, action: #selector(nextGoal))
        self.navigationItem.rightBarButtonItem = nextButton
        
        
        let NSL_goalTitle = NSLocalizedString("NSL_goalTitle", value: "Change yourself by achieving goals!\nLet's set up an achievable, measurable, specific, and worthwhile goal, which achievement gives you practical value to your life or work. \n\"Be the number one fashion photographer.\" is not a goal, it\'s your vision and dream to realize. You set up numerous goals to get closer to your vision. Vision is the top of mountain to climb, and has to be just ONE. Vision doesn't have to be one in your life time, but should be one at time.\n\n\"Complete YouTube video series 'Mastering Fashion Photoshoot Technique\" is a goal to achieve. It's a milestone which let you physically get closer to the top of the mountain.\n\nA task has to be specific and singular action to complete. \"Learn how to take a cool scenery photo\" is not specific enough as a task. \"Research on how to choose the best lense to take a Ocean view photo.\" is specific and small enough to complete. Set one task to complete within a couple of hours.\n\n\"Wake up at 6am every weekday\" is NOT a goal, it's a routine task or habit to establish in order to complete tasks. You could add routine habits to establish as tasks, but these are more likely tasks for a goal \"Establish good daily routines and habits to be more productive to work on tasks\". Buy pickel, a pair of boots, map, water bottle to carry are tasks to get you to a milestone, goal.\n\nSet up a goal which you can complete within 1 - 5 weeks. Setting smaller goals motivates you to achieve more.", comment: "")
        self.goalTitleTextView.text = NSL_goalTitle

    }

    override func viewDidLayoutSubviews() {
        //self.goalTitleTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        self.goalTitleTextView.setContentOffset(.zero, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nextGoal() {

        if goalTitleTextField.text != "" {

            // Call segue to go next
            self.performSegue(withIdentifier: "toGoalDescription", sender: self)
          
        } else {
            let NSL_alertTitle_017 = NSLocalizedString("NSL_alertTitle_017", value: "No Text Entry", comment: "")
            let NSL_alertMessage_017 = NSLocalizedString("NSL_alertMessage_017", value: "This entry is mandatory. Please type one in the text field.", comment: "")
             AlertNotification().alert(title: NSL_alertTitle_017, message: NSL_alertMessage_017, sender: self)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGoalDescription" {
            let destVC  = segue.destination as! GoalDescriptionViewController
            destVC.segueName = segueName
            destVC.goal = goal
            destVC.goalTitle = goalTitleTextField.text!
        }
    }
    
    // MARK: - Dismissing a Keyboard
    // To dismiss a keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalTitleTextField.resignFirstResponder()
        
        return true
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
