//
//  GoalDescriptionViewController.swift
//  Poli
//
//  Created by Tatsuya Moriguchi on 8/1/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit

class GoalDescriptionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    
    
    var segueName: String?
    var goal: Goal!
    var goalTitle: String = ""
    
    @IBAction func cancelToRoot(_ sender: UIButton) {
    navigationController!.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To update goal, show the goal title
        let NSL_goalDescription = NSLocalizedString("NSL_goalDescription", value: "Write the purpose, details, log, etc. of this goal.", comment: "")
        self.instructionLabel.text = NSL_goalDescription

        if segueName == "updateGoal" {
            goalDescriptionTextView.text = goal?.goalDescription
        } else {
            
        }
        
        let NSL_nextButton_02 = NSLocalizedString("NSL_nextButton_02", value: "Next", comment: "")
        let nextButton = UIBarButtonItem(title: NSL_nextButton_02, style: .done, target: self, action: #selector(nextGoal))
        self.navigationItem.rightBarButtonItem = nextButton

        goalDescriptionTextView.delegate = self
        
    }
    

    
    // MARK: - Dismissing a Keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /*
         if text == "\n" {
         goalDescriptionTextView.resignFirstResponder()
         return false
         }
         */
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nextGoal() {
        
        self.performSegue(withIdentifier: "toGoalDueDate", sender: self)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "toGoalDueDate" {
            let destVC  = segue.destination as! GoalDueDateViewController
            destVC.segueName = segueName
            destVC.goal = goal
            destVC.goalTitle = goalTitle
            destVC.goalDescription = goalDescriptionTextView.text
        }
    }
  
}
