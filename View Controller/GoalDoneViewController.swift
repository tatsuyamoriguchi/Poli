//
//  GoalDoneViewController.swift
//  Poli
//
//  Created by Tatsuya Moriguchi on 8/8/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class GoalDoneViewController: UIViewController {

    var goal: Goal!
    var goalDone: Bool!
    var userName: String = ""

    
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalDoneSwitch: UISwitch!
    
    @IBAction func cancelButton(_ sender: UIButton) {
        navigationController!.popToRootViewController(animated: true)
    }
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userName != "" {
            let NSL_naviPrompt = String(format:NSLocalizedString("NSL_naviPormpt", value: "Login as %@", comment: ""), userName)
            self.navigationItem.prompt = NSL_naviPrompt
        } else {
            let NSL_naviMissing = NSLocalizedString("NSL_naviMissing", value: "Login info is missing!", comment: "")
            self.navigationItem.prompt = NSL_naviMissing
        }
        goalTitleLabel.text = goal.goalTitle
        goalDoneSwitch.isOn = goal.goalDone
        
        let undoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(undoneGoal))
        self.navigationItem.rightBarButtonItem = undoneButton
        // Do any additional setup after loading the view.
    }
    
    @objc func undoneGoal() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        goal.goalDone = goalDoneSwitch.isOn
        
        do {
            try context.save()
        }catch{
            print("Saving Error: \(error.localizedDescription)")
        }

        //navigationController!.popToRootViewController(animated: true)
        performSegue(withIdentifier: "toGoalList", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGoalList" {
            let destVC = segue.destination as! GoalTableViewController
            destVC.userName = userName
    
        }
    }
 

}
