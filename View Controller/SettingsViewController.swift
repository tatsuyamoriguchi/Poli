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
    @IBOutlet weak var goToSettingsButton: UIButton!
    
    @IBAction func goToSettingsPressed(_ sender: UIButton) {
        
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
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
                DispatchQueue.main.sync {
                    self.notificationAlertLabel.isHidden = true
                    self.notificationTimePicker.isHidden = false
                    self.notificationSetButton.isHidden = false
                    self.goToSettingsButton.isHidden = true
                    
                    if let storedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
                        self.notificationTimePicker.setDate(storedTime, animated: true)
                    }
                }
              
            } else {
                DispatchQueue.main.sync {
                // Permissions are not granged
                self.notificationAlertLabel.isHidden = false
                self.notificationTimePicker.isHidden = true
                self.notificationSetButton.isHidden = true
                    self.goToSettingsButton.isHidden = false
                }
            }
        }
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
        
        //UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.subtitle = "Open PoliPoli"
        content.body = "Time to focus on tasks to-do!"
        content.sound = UNNotificationSound.default()


        let dateComponent = notificationTimePicker.calendar.dateComponents([.hour, .minute], from: (notificationTimePicker.date))
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // Stored notificationTimePicker.date info to UserDefaults
        // Nexttime opening Settings view, it shows pre-defined time in DatePicker
        UserDefaults.standard.set(notificationTimePicker.date, forKey: "notificationTime")
 
        
        // Attach image to notificaiton
        guard let path = Bundle.main.path(forResource: "PoliPoliIconSmall", ofType: "png")
        else {
            print("unable to find image!")
            return }

        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        } catch {
            print("The attachement could not be loaded.")
        }

        
        //let notificationReq = UNNotificationRequest(identifier: "DailyReminder", content: content, trigger: trigger)
        let notificationReq = UNNotificationRequest(identifier: "DailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
       /* UNUserNotificationCenter.current().add(notificationReq) { (error: Error?) in

            if let error = error {
                print("Error: \(error).localizedDescription)")
            }
        }
 */
        let center = UNUserNotificationCenter.current()
        center.add(notificationReq) { (error) in
            print("Error: \(String(describing: error))")
        }
        
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
