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
            
            if goal.goalRewardImage == nil {
               //if no image exists 'cause perhaps it was deleted from Photos, use PoliPoli default image
                goalRewardImageView.image = #imageLiteral(resourceName: "PoliPoliIcon.png")
                
            } else {
            
                goalRewardImageView.image = UIImage(data: goal.goalRewardImage! as Data)
            }
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
            goal.goalRewardImage =  goalRewardImageView.image!.pngData() as NSData?
            goal.goalDone = false
            
        } else {
            let goal = Goal(context: context)
            goal.goalTitle = goalTitle
            goal.goalDescription = goalDescription
            goal.goalDueDate = goalDueDate! as NSDate
            goal.goalReward = goalRewardTextField.text // goalReward
            goal.goalRewardImage =  goalRewardImageView.image!.pngData() as NSData?
            goal.goalDone = false
        }
       
            do {
                try context.save()
            }catch{
                print("Saving Error: \(error.localizedDescription)")
            }
        
            navigationController!.popToRootViewController(animated: true)
        
    }
    
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        imagePicker()
    }
    
    
    func imagePicker() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let NSL_alertTitle_018 = NSLocalizedString("NSL_alertTitle_018", value: "Photo Source", comment: "")
        let NSL_alertMessage_018 = NSLocalizedString("NSL_alertMessage_018", value: "Choose a photo.", comment: "")
        let actionSheet = UIAlertController(title: NSL_alertTitle_018, message: NSL_alertMessage_018, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let NSL_alertTitle_019 = NSLocalizedString("NSL_alertTitle_019", value: "Camera", comment: "")
            actionSheet.addAction(UIAlertAction(title: NSL_alertTitle_019, style: .default, handler: { (action: UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        } else {
            print("\n")
            print("Camera is not available.")
            print("\n")
        }
        let NSL_alertTitle_020 = NSLocalizedString("NSL_alertTitle_020", value: "Photo Library", comment: "")
        actionSheet.addAction(UIAlertAction(title: NSL_alertTitle_020, style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        let NSL_cancelButton = NSLocalizedString("NSL_cancelButton", value: "Cancel", comment: "")
        actionSheet.addAction(UIAlertAction(title: NSL_cancelButton, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
       
        //goalRewardImageView.image = image
        //To avoid captured photo's orientation issue, use fixOrientation()
        let orientationFixedImage = image?.fixOrientation()
        goalRewardImageView.image = orientationFixedImage
        
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

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
