//
//  GoalRewardViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/1/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class GoalRewardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var goalRewardTextField: UITextField!
    @IBOutlet weak var goalRewardImageView: UIImageView!
    
    @IBAction func cancelToRoot(_ sender: UIButton) {
         navigationController!.popToRootViewController(animated: true)
    }
    
    var segueName:String?
    var goal: Goal!
    var goalTitle: String = ""
    var goalDescription: String = ""
    var goalDueDate: Date?
    var goalReward: String?
    var goalRewardImage: UIImage?
    var imagePickerController: UIImagePickerController?

    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To update goal, show the goal title
        if segueName == "updateGoal" {
            goalRewardTextField.text = goal.goalReward
            goalRewardImageView.image = UIImage(data: goal.goalRewardImage! as Data)
        }
        
        let nextButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nextGoal))
        self.navigationItem.rightBarButtonItem = nextButton
        goalRewardTextField.delegate = self
 
        imagePickerController?.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nextGoal() {
        //goalReward = goalRewardTextField.text
        //goalRewardImage = goalRewardImageView.image
 
        /*print(goalTitle)
        print(goalDescription)
        print(goalDueDate)
        print(goalReward)
        print(goalRewardImage)
        */
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if segueName == "updateGoal" {
            goal.goalTitle = goalTitle
            goal.goalDescription = goalDescription
            goal.goalDueDate = goalDueDate! as NSDate
            goal.goalReward = goalRewardTextField.text // goalReward
            goal.goalRewardImage =  UIImagePNGRepresentation(goalRewardImageView.image!) as NSData?
            goal.goalDone = false
            
        } else {
            let goal = Goal(context: context)
            goal.goalTitle = goalTitle
            goal.goalDescription = goalDescription
            goal.goalDueDate = goalDueDate! as NSDate
            goal.goalReward = goalRewardTextField.text // goalReward
            goal.goalRewardImage =  UIImagePNGRepresentation(goalRewardImageView.image!) as NSData?
            goal.goalDone = false
        }
       
            do {
                try context.save()
            }catch{
                print("Saving Error: \(error)")
            }
        
            navigationController!.popToRootViewController(animated: true)
        
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
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage

        goalRewardImageView.image = image

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Dismissing a Keyboard
    // To dismiss a keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalRewardTextField.resignFirstResponder()
        
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
  

}


