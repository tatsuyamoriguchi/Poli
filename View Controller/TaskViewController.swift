//
//  TaskViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 7/17/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var isImportantSwitch: UISwitch!
    
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var isDoneSwitch: UISwitch!
    
    private var datePicker: UIDatePicker?
    
    var segueName: String?
    var selectedGoal: Goal?
    var selectedTask: Task!
    var context: NSManagedObjectContext!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        if segueName == "addTask" {
            isDoneSwitch.isOn = false
            let NSL_naviAdd = NSLocalizedString("NSL_naviAdd", value: "Add Task", comment: "")
            self.navigationItem.title = NSL_naviAdd
        } else if segueName == "updateTask" {
            toDoTextField.text = selectedTask.toDo
            isImportantSwitch.isOn = selectedTask.isImportant
            taskDatePicker.date = selectedTask.date! as Date
            isDoneSwitch.isOn = selectedTask.isDone
            let NSL_naviUpdate = NSLocalizedString("NSL_naviUpdate", value: "Update Task", comment: "")
            self.navigationItem.title = NSL_naviUpdate

        } else {
            print("Error: segueName wasn't detected.")
            let NSL_naviError = NSLocalizedString("NSL_naviError", value: "Error: segueName wasn't detected", comment: "")
            self.navigationItem.title = NSL_naviError

        }
        
        // Do any additional setup after loading the view.
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
        self.navigationItem.rightBarButtonItem = saveButton
        
        // To dismiss a keyboard
        toDoTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveTask() {

        if toDoTextField.text != "" {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if segueName == "updateTask" {
                
                selectedTask.toDo = toDoTextField.text
                selectedTask.isImportant = isImportantSwitch.isOn
                
                selectedTask.isDone = isDoneSwitch.isOn
                selectedTask.date = taskDatePicker.date as Date as NSDate
                
            }else if segueName == "addTask" {
                
                let task = Task(context: context)
                
                task.toDo = toDoTextField.text
                task.isImportant = isImportantSwitch.isOn
                task.date = taskDatePicker.date as NSDate
                task.isDone = false
                task.goalAssigned = selectedGoal
                
            }else {
                print("segueName wasn't detected.")
            }
            
            do {
                try context.save()
            }catch{
                print("Saving Error: \(error.localizedDescription)")
            }
            
            navigationController!.popViewController(animated: true)
            
        } else if toDoTextField.text == "" {
            let NSL_alertTitle_024 = NSLocalizedString("NSL_alertTitle_024", value: "No Text Entry", comment: "")
            let NSL_alertMessage_024 = NSLocalizedString("NSL_alertMessage_024", value: "This entry is mandatory. Please type one in the text field.", comment: "")
            AlertNotification().alert(title: NSL_alertTitle_024, message: NSL_alertMessage_024, sender: self)
        } else {
            print("Unable to detect toDoTextField.text value.")
        }
    }


    // To dismiss a keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toDoTextField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
