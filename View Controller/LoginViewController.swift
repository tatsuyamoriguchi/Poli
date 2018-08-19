//
//  LoginViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/4/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import QuartzCore

class LoginViewController: UIViewController, UITextFieldDelegate, CAAnimationDelegate, CALayerDelegate {

    // MARL: - ANIMATION
    // Declare a layer variable for animation
    var mask: CALayer?

    // Image View for animation
    //@IBOutlet weak var imageView: UIImageView!
    
 
    
    
    
    // MARK: - LOGIN VIEW
    // Variables
    var userName: String = ""
    var userPassword: String = ""
    var isOpening: Bool = true
    
    // Properties
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        userName = userNameTextField.text!
        userPassword = passwordTextField.text!
        
        // User login account already exists alert
        if (UserDefaults.standard.object(forKey: "userName") as? String) != nil {
            
            AlertNotification().alert(title: "User Already Exists", message: "This App already has a user. To change your user info, login PoliPoli and go to Settings.", sender: self)
            
        } else if userNameTextField.text == "" || passwordTextField.text == "" {
            // no enough input entry alert
            AlertNotification().alert(title: "Need More Information", message: "Fill both information: User Name and Password", sender: self)
        } else {
            // Set a user login account
            UserDefaults.standard.set(userName, forKey: "userName")
            UserDefaults.standard.set(userPassword, forKey: "userPassword")
            userNameTextField.text = ""
            passwordTextField.text = ""
            AlertNotification().alert(title: "User Account Created", message: "Please use the user name and password just created to login PoliPoli.", sender: self)
            
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
       
        userName = userNameTextField.text!
        userPassword = passwordTextField.text!
        
        let storedUserName = UserDefaults.standard.object(forKey: "userName") as? String
        let storedPassword = UserDefaults.standard.object(forKey: "userPassword") as? String
        
        if  (storedUserName == nil) {
            AlertNotification().alert(title: "No Account", message: "No account is registered yet. Please create an account.", sender: self)
        } else if userName == storedUserName && userPassword == storedPassword {
            
            performSegue(withIdentifier: "loginSegue", sender: nil)
            
        } else {
            AlertNotification().alert(title: "Authentification Failed", message: "Data you entered didn't match with user information.", sender: self)
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
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        
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
