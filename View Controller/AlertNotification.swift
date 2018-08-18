//
//  AlertNotification.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/6/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import Foundation
import UIKit

class AlertNotification: UIViewController {
    
    // Alert with passing title and message
    func alert(title: String, message: String, sender: Any) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        (sender as AnyObject).present(alert, animated: true, completion: nil)
    }
    
}
