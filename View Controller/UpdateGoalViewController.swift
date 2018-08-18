//
//  UpdateGoalViewController.swift
//  ToDoApp3
//
//  Created by Tatsuya Moriguchi on 7/23/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class UpdateGoalViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate  {
    
    var goal: Goal!
    
    @IBOutlet weak var goalTitleTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var goalDueDatePicker: UIDatePicker!
    @IBOutlet weak var goalRewardTextField: UITextField!
    @IBOutlet weak var goalRewardImageView: UIImageView!
    
    private var datePicker: UIDatePicker?
    
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        goalTitleTextField.text = goal.goalTitle
        goalDescriptionTextView.text = goal.goalDescription
        goalDueDatePicker.date = goal.goalDueDate! as Date
        goalRewardTextField.text = goal.goalReward
        if let imageData = goal.goalRewardImage as Data? {
            goalRewardImageView.image = UIImage(data: imageData)
        }else{
            goalRewardImageView.image = UIImage(named: "DefaultRewardImage")
        }
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGoal))
        self.navigationItem.rightBarButtonItem = saveButton
    
        // To dismiss a keyboard
        goalTitleTextField.delegate = self
        //goalDescriptionTextView.delegate = self
        goalRewardTextField.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveGoal(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        goal.goalTitle = goalTitleTextField.text!
        goal.goalDescription = goalDescriptionTextView.text
        
        goal.goalDueDate = goalDueDatePicker.date as NSDate
        
        goal.goalReward = goalRewardTextField.text
        goal.goalRewardImage = UIImagePNGRepresentation(goalRewardImageView.image!) as NSData?
        goal.goalDone = false
        
        do {
            try context.save()
        }catch{
            print("Saving Error: \(error)")
        }
        
        navigationController!.popViewController(animated: true)
        
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        imagePicker()
    }
    
    
    func imagePicker() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo.", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        } else {
            print("\n")
            print("Camera is not available.")
            print("\n")
        }
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        goalRewardImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
