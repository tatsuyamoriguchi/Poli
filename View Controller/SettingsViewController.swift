//
//  SettingsViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/4/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notificationAlertLabel: UILabel!
    @IBOutlet weak var notificationSetButton: UIButton!
    
    
    @IBAction func updateAccountPressed(_ sender: UIButton) {
        updateAccount()
    }
    
    @IBOutlet weak var notificationTimePicker: UIDatePicker!
    
    @IBAction func notificationSetPressed(_ sender: UIButton) {
        // Obtain Notificaiton Time Set information from UIDatePicker
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let notificationTime = timeFormatter.string(from: notificationTimePicker.date)
        // Alert with notificaitonTime, Clicking OK fires notificaiton at preset time, Cancel terminates notification
        alert(title: "Notificaiton Time Set", message: "\(notificationTime)", actionPassed: setNotification)
        
        
    }
    
    var userName: String! = ""
    var userPassword: String! = ""
    let storedUserName = UserDefaults.standard.object(forKey: "userName") as? String
    let storedPassword = UserDefaults.standard.object(forKey: "userPassword") as? String
  
    
    var timePicker: UIDatePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        //userName = "dummy"
        if userName != storedUserName {
            alert(title: "User Name Mismatched", message: "User Name you used doesn't match with stored one, somehow. Please press ok to go back to Login view and re-login.", actionPassed: loginSegue)
            
        } else {
            userNameTextField.text = storedUserName
            passwordTextField.text = storedPassword
        }
        
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Permissions are granted
                self.notificationAlertLabel.isHidden = true
                self.notificationTimePicker.isHidden = false
                self.notificationSetButton.isHidden = false
                
            } else {
                // Permissions are not granged
                self.notificationAlertLabel.isHidden = false
                self.notificationTimePicker.isHidden = true
                self.notificationSetButton.isHidden = true
            }
        }
        
//        self.navigationItem.rightBarButtonItem = self.
        //let settings = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updatePressed))
        //navigationItem.rightBarButtonItems = [settings]
        // Do any additional setup after loading the view.
    }

    // To dismiss a keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateAccount() {
        
        userName = userNameTextField.text!
        userPassword = passwordTextField.text!

        if userNameTextField.text == "" || passwordTextField.text == "" {
            // no enough input entry alert
            alert(title: "Need More Information", message: "Fill both information: User Name and Password", actionPassed: noAction)
            
        } else {
            // Set a user login account
            UserDefaults.standard.set(userName, forKey: "userName")
            UserDefaults.standard.set(userPassword, forKey: "userPassword")
            userNameTextField.text = ""
            passwordTextField.text = ""
            alert(title: "User Information Updated", message: "Please re-login with new user information.", actionPassed: loginSegue)
            
        }
    }
    
    func setNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Today's Task To-Do Reminder"
        content.subtitle = "Hello this is sub title"
        content.body = "this is Body."
        content.sound = UNNotificationSound.default()
        
        //let dateComponent = notificationTimePicker.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: (notificationTimePicker.date))
        let dateComponent = notificationTimePicker.calendar.dateComponents([.hour, .minute], from: (notificationTimePicker.date))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let notificationReq = UNNotificationRequest(identifier: "DailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(notificationReq, withCompletionHandler: nil)
        
        goalListSegue()
    }
    
    func alert(title: String, message: String, actionPassed: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            actionPassed()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func noAction() {
        // Do nothing for  alert
    }
/*
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.loginSegue()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
*/
    func loginSegue() {
        performSegue(withIdentifier: "backtoLoginSegue", sender: nil)
    }

    func goalListSegue() {
        performSegue(withIdentifier: "ToGoalListSegue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToGoalListSegue" {
            let destVC = segue.destination as! GoalTableViewController
            destVC.userName = userName
        }
    }


}
