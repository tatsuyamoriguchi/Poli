//
//  UpdateTaskViewController.swift
//  ToDoApp3
//
//  Created by Tatsuya Moriguchi on 7/28/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit

class UpdateTaskViewController: UIViewController, UITextFieldDelegate {

    var selectedTask: Task!
    
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var isImportantSwitch: UISwitch!
   
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var isDoneSwitch: UISwitch!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        toDoTextField.text = selectedTask.toDo
        isImportantSwitch.isOn = selectedTask.isImportant
        taskDatePicker.date = selectedTask.date! as Date
        isDoneSwitch.isOn = selectedTask.isDone

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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        selectedTask.toDo = toDoTextField.text
        selectedTask.isImportant = isImportantSwitch.isOn
        
        selectedTask.isDone = isDoneSwitch.isOn
        selectedTask.date = taskDatePicker.date as Date as NSDate
        
        if toDoTextField.text != "" {
        do {
            try context.save()
            
        }catch{
            print("Saving Error: \(error)")
        }
        
        navigationController!.popViewController(animated: true)
        } else {
            AlertNotification().alert(title: "No Text Entry", message: "This entry is mandatory. Please type one in the text field.", sender: self)

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
