//
//  UpdateGoalViewController.swift
//  ToDoApp3
//
//  Created by Tatsuya Moriguchi on 7/23/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class UpdateGoalViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var goalTitle: String?
    var goalDescription: String?
    var goalDueDate: NSDate?
    var goalReward: String?
    var goalRewardImage: UIImage?
    var goalDone: Bool?
    
    
    // Porperties
    @IBOutlet weak var goalTitleTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var goalDueDatePicker: UIDatePicker!
    @IBOutlet weak var goalRewardTextField: UITextField!
    @IBOutlet weak var goalRewardImageView: UIImageView!
    
    var context: NSManagedObjectContext!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let updateButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateGoal))
        self.navigationItem.rightBarButtonItem = updateButton
        /*
        //datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMMM dd, yyyy"
        let date = dateFormatter.string(from: (goal.goalDueDate)! as Date)
        goalCell.goalDueDateLabel.text = "Due Date: \(date)"
        */
        
        goalTitleTextField.text = goalTitle
        goalDescriptionTextView.text = goalDescription
        goalDueDatePicker.date = Date()
            //goalDueDate as Date
        goalRewardTextField.text = goalReward
        goalRewardImageView.image = goalRewardImage
        
    }
    
    @objc func updateGoal(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let goal = Goal(context: context)
        
        goal.goalTitle = goalTitleTextField.text!
        goal.goalDescription = goalDescriptionTextView.text
        
        goal.goalDueDate = goalDueDatePicker.date as NSDate
        
        goal.goalReward = goalRewardTextField.text
        goal.goalRewardImage = UIImagePNGRepresentation(goalRewardImageView.image!) as NSData?
        
        goal.tasksAssigned = nil
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

