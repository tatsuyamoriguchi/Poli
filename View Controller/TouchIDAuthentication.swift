//
//  TouchIDAuthentication.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 11/20/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import Foundation
import LocalAuthentication


enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    let context = LAContext()

    var loginReason = "Logging in with Touch ID"
    
    // Find if biometric ID is available to the user's device.
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
    }

    // To return which biometric type is supported on the device
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        // 1        authenticateUser(completion:) takes a completion handler in the form of a closure.
        
        
        // 2 You’re using canEvaluatePolicy() to check whether the device is capable of biometric authentication.
        guard canEvaluatePolicy() else {
            
            completion("Touch ID not available")
            return
        }
        
        // 3 If the device does support biometric ID, you then use evaluatePolicy(_:localizedReason:reply:) to begin the policy evaluation — that is, prompt the user for biometric ID authentication. evaluatePolicy(_:localizedReason:reply:) takes a reply block that is executed after the evaluation completes.
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: loginReason) { (success, evaluateError) in
                                // 4 Inside the reply block, you are handling the success case first. By default, the policy evaluation happens on a private thread, so your code jumps back to the main thread so it can update the UI. If the authentication was successful, you will call the segue that dismisses the login view.
                                if success {
                                    DispatchQueue.main.async {
                                        // User authenticated successfully, take appropriate action
                                        completion(nil)
                                    }
                                } else {
                                    // 1 Declare a sring to hold the message.
                                    let message: String
                                    
                                    // 2 For the failure case, use a switch statement to set appropriate error
                                    // messages for each error case, then present the user with an alert view.
                                    switch evaluateError {
                                    // 3
                                    case LAError.authenticationFailed?:
                                        message = "There was a problem verifying your identity."
                                    case LAError.userCancel?:
                                        message = "You pressed cancel."
                                    case LAError.userFallback?:
                                        message = "Please enter your user name and password."
                                    case LAError.biometryNotAvailable?:
                                        message = "Face ID/Touch ID is not available."
                                    case LAError.biometryNotEnrolled?:
                                        message = "Face ID/Touch ID is not set up."
                                    case LAError.biometryLockout?:
                                        message = "Face ID/Touch ID is locked."
                                    default:
                                        message = "Face ID/Touch ID may not be configured"
                                    }
                                    // 4 Pass the message in the completion closure.
                                    completion(message)
                                }
        }
    }
    
}

