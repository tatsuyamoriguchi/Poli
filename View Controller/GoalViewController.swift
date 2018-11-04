//
//  GoalViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 7/17/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class GoalViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    // Porperties
    @IBOutlet weak var goalTitleTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var goalDueDatePicker: UIDatePicker!
    @IBOutlet weak var goalRewardTextField: UITextField!
    @IBOutlet weak var goalRewardImageView: UIImageView!
    
    var context: NSManagedObjectContext!

    private var datePicker: UIDatePicker?
    var goal = Goal()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveGoal))
        self.navigationItem.rightBarButtonItem = saveButton
        datePicker = UIDatePicker()

        goalTitleTextField.delegate = self
        //goalDescriptionTextView.delegate = self
        goalRewardTextField.delegate = self

    }
    

    @objc func saveGoal(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let goal = Goal(context: context)
        //let task = Task(context: context)
        
        goal.goalTitle = goalTitleTextField.text!
        goal.goalDescription = goalDescriptionTextView.text
        
        goal.goalDueDate = goalDueDatePicker.date as NSDate
        
        goal.goalReward = goalRewardTextField.text
        goal.goalRewardImage = goalRewardImageView.image!.pngData() as NSData?
        goal.goalDone = false
        //task.goalAssigned = goal
        //goal.addToTasksAssigned(task)
        
        do {
            try context.save()
        }catch{
            print("Saving Error: \(error.localizedDescription)")
        }
        
        navigationController!.popViewController(animated: true)
    
    }
 
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // To dismiss a keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalTitleTextField.resignFirstResponder()
        goalRewardTextField.resignFirstResponder()
       
        return true
    }
    
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
