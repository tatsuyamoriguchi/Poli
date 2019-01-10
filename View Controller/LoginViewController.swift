//
//  LoginViewController.swift
//  Poli
//
//  Created by Tatsuya Moriguchi on 8/4/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import QuartzCore

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "Poli"
    static let accessGroup: String? = nil
}

class LoginViewController: UIViewController, UITextFieldDelegate, CAAnimationDelegate, CALayerDelegate {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createLogin: UIButton!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var touchIDButton: UIButton!
    
    var passwordItems: [KeychainPasswordItem] = []
    
    
    // MARK: - ANIMATION
    // Declare a layer variable for animation
    var mask: CALayer?

    
    // MARK: - LOGIN VIEW
    // Variables
    var userName: String = ""
    var userPassword: String = ""
    var isOpening: Bool = true
    
    // Create a reference to BiometricIDAuth
    let touchMe = BiometricIDAuth()
    
    
    // Properties
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        userName = userNameTextField.text!
        userPassword = passwordTextField.text!
        
        // User login account already exists alert
        if (UserDefaults.standard.object(forKey: "userName") as? String) != nil {
            let NSL_alertTitle_001 = NSLocalizedString("NSL_alertTitle_001", value: "User Already Exists", comment: "")
            let NSL_alertMessage_001 = NSLocalizedString("NSL_alertMessage_001", value: "This App already has a user. To change your user info, login Poli and go to Settings.", comment: " ")
            
            AlertNotification().alert(title: NSL_alertTitle_001, message: NSL_alertMessage_001, sender: self)
            
            // If any of user info is missing, display an alert.
        } else if userNameTextField.text == "" || passwordTextField.text == "" {
            // no enough input entry alert
            let NSL_alertTitle_002 = NSLocalizedString("NSL_alertTitle_002", value: "Need More Information", comment: " ")
            let NSL_alertMessage_002 = NSLocalizedString("NSL_alertMessage_002", value: "Fill both information: User Name and Password", comment: " ")
            AlertNotification().alert(title: NSL_alertTitle_002, message: NSL_alertMessage_002, sender: self)


        } else {
     
            // Create a KeychainPasswordItem with the service Name, newAccountName(username) and accessGroup. Using Swift's error handling, you try to save the password. The catch is there if something goes wrong.
            do {
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: userName, accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(userPassword)
                
            }catch {
                fatalError("Error updating keychain = \(error)")
            }
            
            
            // Set a user login account
            UserDefaults.standard.set(userName, forKey: "userName")
            //UserDefaults.standard.set(userPassword, forKey: "userPassword")
            
            userNameTextField.text = ""
            passwordTextField.text = ""
            
            let NSL_alertTitle_003 = NSLocalizedString("NSL_NSL_alertTitle_003", value: "User Account Created", comment: " ")
            let NSL_alertMessage_003 = NSLocalizedString("NSL_alertMessage_003", value: "Please use the user name and password just created to login Poli.", comment: " ")
            AlertNotification().alert(title: NSL_alertTitle_003, message: NSL_alertMessage_003, sender: self)
            
        }
    }
 
  
    @IBAction func loginPressed(_ sender: UIButton) {
       
        userName = userNameTextField.text!
        userPassword = passwordTextField.text!
        
        let storedUserName = UserDefaults.standard.object(forKey: "userName") as? String
        //let storedPassword = UserDefaults.standard.object(forKey: "userPassword") as? String
        
        if  (storedUserName == nil) {
            let NSL_alertTitle_004 = NSLocalizedString("NSL_alertTitle_004", value: "No Account", comment: " ")
            let NSL_alertMessage_004 = NSLocalizedString("NSL_alertMessage_004", value: "No account is registered yet. Please create an account.", comment: " ")
            AlertNotification().alert(title: NSL_alertTitle_004, message: NSL_alertMessage_004, sender: self)
        }
        //else if userName == storedUserName && userPassword == storedPassword {
            
            // If the user is logging in, call checkLogin to verify the user-provided credentials; if they match then you dismiss the login view.
            else if checkLogin(username: userName, password: userPassword) {
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            performSegue(withIdentifier: "loginSegue", sender: self)

            
        } else {
            let NSL_alertTitle_005 = NSLocalizedString("NSL_alertTitle_005", value: "Authentification Failed", comment: " ")
            let NSL_alertMessage_005 = NSLocalizedString("NSL_alertMessage_005", value: "Data you entered didn't match with user information.", comment: " ")
            AlertNotification().alert(title: NSL_alertTitle_005, message: NSL_alertMessage_005, sender: self)
        }
    }
    
    @IBAction func touchIDLoginAction() {
        /*
         touchMe.authenticateUser() { [weak self] inrr
         self?.performSegue(withIdentifier: "loginSegue", sender: self)
         }
         */
        
        // 1 Update the trailing closure to accept an optional message.
        // If biometric ID works, no message.
        touchMe.authenticateUser() { [weak self] message in
            // 2 Unwrap the message and display it with an alert.
            if (UserDefaults.standard.object(forKey: "userName") as? String) == nil {
                AlertNotification().alert(title: "Error", message: "No User Name found", sender: self!)
            
        } else if let message = message {
                // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Error",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Darn!", style: .default)
                alertView.addAction(okAction)
                self?.present(alertView, animated: true)
            } else {
           
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                
                // 3 if no message, dismiss the Login view.
                self?.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        
    }
    
    
    
    
    
    func checkLogin(username: String, password: String) -> Bool {
        
        guard username == UserDefaults.standard.value(forKey: "userName") as? String else {
            return false
        }
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
   
        } catch {
            fatalError("Error reading passwod from keychain - \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Opening Animation
        maskView()
        animate()
        
        // Opening Sound
        if isOpening != false {
            PlayAudio.sharedInstance.playClick(fileName: "bigdog", fileExt: ".wav")
            isOpening = false
        }
        userNameTextField.delegate = self
        passwordTextField.delegate = self

        // Find whether the device can implement biometric authentication
        // If so, show the Touch ID button.
        touchIDButton.isHidden = !touchMe.canEvaluatePolicy()
        
        // Fix the button's icon
        switch touchMe.biometricType() {
        case .faceID:
            touchIDButton.setImage(UIImage(named: "FaceIcon"),  for: .normal)
        default:
            touchIDButton.setImage(UIImage(named: "Touch-icon-lg"),  for: .normal)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let touchBool = touchMe.canEvaluatePolicy()
        if touchBool {
            touchIDLoginAction()
        }
    }
    

    // Create a layer
    func maskView() {
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "dogpow")!.cgImage
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        view.layer.mask = mask
    }
    
    // Do Animation
    func animate() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1
        
        keyFrameAnimation.duration = 2
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
        
        let initialBounds = NSValue(cgRect: mask!.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 60, height: 60))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1500, height: 1500))
        keyFrameAnimation.values = [initialBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        self.mask!.add(keyFrameAnimation, forKey: "bounds")
        
    }
    
    // Remove sublayer after animation is done to expose login view
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        mask?.removeFromSuperlayer()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    // Refactoring alert message
    // Learn how to pass action to handler
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
*/
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "loginSegue" {
            let destVC = segue.destination as! UINavigationController
            let targetVC = destVC.topViewController as! GoalTableViewController
            targetVC.userName = userName
            
        }
        // Pass the selected object to the new view controller.
    }
    

}
