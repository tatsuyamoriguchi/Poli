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

        let nextButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nextGoal))
        self.navigationItem.rightBarButtonItem = nextButton
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
             AlertNotification().alert(title: "No Text Entry", message: "This entry is mandatory. Please type one in the text field.", sender: self)
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
