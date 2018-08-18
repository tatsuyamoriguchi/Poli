//
//  SettingsViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/4/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    var userName: String! = ""
    var userPassword: String! = ""
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let storedUserName = UserDefaults.standard.object(forKey: "userName") as? String
    let storedPassword = UserDefaults.standard.object(forKey: "userPassword") as? String
    
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
        
//        self.navigationItem.rightBarButtonItem = self.
        let settings = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updatePressed))
        navigationItem.rightBarButtonItems = [settings]
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
    
    @objc func updatePressed(_ sender: UIButton) {
        
        userName = userNameTextField.text!
        userPassword = passwordTextField.text!

        if userNameTextField.text == "" || passwordTextField.text == "" {
            // no enough input entry alert
            //print("3: \(userIDTextField.text)")
            //print("4: \(passwordTextField.text)")
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
    
    
    func alert(title: String, message: String, actionPassed: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            actionPassed()
        }))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backtoLoginSegue" {
            let destVC = segue.destination as! LoginViewController
        }
    }
  */

}
