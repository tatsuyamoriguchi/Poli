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
    
}

