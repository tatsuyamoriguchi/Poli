//
//  GoalDescriptionViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/1/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit

class GoalDescriptionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalDescriptionTextView: UITextView!
    var segueName: String?
    var goal: Goal!
    var goalTitle: String = ""
    
    @IBAction func cancelToRoot(_ sender: UIButton) {
    navigationController!.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To update goal, show the goal title
        if segueName == "updateGoal" {
            goalDescriptionTextView.text = goal?.goalDescription
        }
        
        let nextButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nextGoal))
        self.navigationItem.rightBarButtonItem = nextButton

        // Do any additional setup after loading the view.
        goalDescriptionTextView.delegate = self
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
    // MARK: - Dismissing a Keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            goalDescriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
