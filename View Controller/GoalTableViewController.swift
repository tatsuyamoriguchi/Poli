//
//  GoalTableViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 7/17/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class GoalTableViewController: UITableViewController {
    
    var userName: String! = ""
    
    var goals = [Goal]()
    var tasks = [Task]()
    // Declare a variable to pass to UpdateGoalViewController
    var selectedGoal: Goal?
    var selectedIndex: Int = 0
   
    @IBAction func logoutPressed(_ sender: Any) {
        // Logout and back to login view
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.prompt = "Login as \(userName!)"
        
        
        //let logout = UIBarButtonItem(barButtonSystemItem: .cancel , target: self, action: #selector(logoutPressed(_:)))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(_:)))
        //let settings = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingsPressed))
        let settings = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(settingsPressed))
        let todaysTasks = UIBarButtonItem(title: "Today's Tasks", style: .plain, target: self, action: #selector(todaysTasksPressed))
        
        navigationItem.rightBarButtonItems = [logout, settings, todaysTasks]
        
        
    }
    
    @objc func todaysTasksPressed() {
        performSegue(withIdentifier: "todaysTasksSegue", sender: nil)
    }
    
    @objc func settingsPressed() {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Fetch the data from Core Data
        fetchData()
        // Reload the table view
        tableView.reloadData()

    }
    
    func fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        // Declare sort descriptor
        let sortByDone = NSSortDescriptor(key: #keyPath(Goal.goalDone), ascending: true)
        let sortByDueDate = NSSortDescriptor(key: #keyPath(Goal.goalDueDate), ascending: true)
        let sortByTitle = NSSortDescriptor(key: #keyPath(Goal.goalTitle), ascending: true)
        // Sort fetchRequest array data
        fetchRequest.sortDescriptors = [sortByDone, sortByDueDate, sortByTitle]
        
        do {
            goals = try context.fetch(fetchRequest)
        }catch{

            print("\n")
            print("Fetch Error: \(error)")
        }
    }
    
    func addMoreTask(goal: Goal, indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "taskList", sender: self)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goalCell = tableView.dequeueReusableCell(withIdentifier: "goalListCell", for: indexPath) as! GoalTableViewCell

        // Configure the cell...
        let goal = goals[indexPath.row]
        
        goalCell.goalTitleLabel.text = goal.goalTitle
        goalCell.goalDescriptionTextView.text = goal.goalDescription
        goalCell.goalRewardLabel.text = "Reward: " + (goal.goalReward)!
        
        if let goalRewardImageData = goal.goalRewardImage as Data? {
            goalCell.goalRewardImageView.image = UIImage(data: goalRewardImageData)
        } else {
            goalCell.goalRewardImageView.image = #imageLiteral(resourceName: "PoliPoliIcon")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMMM dd, yyyy"
        let date = dateFormatter.string(from: (goal.goalDueDate)! as Date)
        
        goalCell.goalDueDateLabel.text = "Due Date: \(date)"
        
        
/*
         // Change background color in every other cell
         // Not much meaningful
        if indexPath.row % 2 == 0 {
            goalCell.goalDescriptionTextView.backgroundColor = .white
            goalCell.backgroundColor = .white
        } else {
            goalCell.goalDescriptionTextView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
            goalCell.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)

        }
*/
        
        // Get goalProgress rate
        let goalProgress: Float = GoalProgress().goalProgressCalc(goal: goal, sender: self)
        let goalProgressPercentage100: Float = goalProgress * 100
        goalCell.goalProgressView.transform = CGAffineTransform(scaleX: 1,y: 7)
        
        UIView.animate(withDuration: 3.0) {
            goalCell.goalProgressView.setProgress(goalProgress, animated: true)
        }
        // Display Progress rate and a message in a cell
        let progressMessage: String = GoalProgress().goalProgressAchieved(percentage: goalProgress)
        goalCell.goalProgressPercentageLabel.text = String(format: "%.1f", goalProgressPercentage100) + "% Done, " + progressMessage

        // If all tasks have been done for the first time, display confirmation alert, if ok, change goalDone value to true

        if goal.goalDone == false && goalProgress == 1.0 {
            
            let alert = UIAlertController(title: "Goal Achieved?", message: "All tasks registered to \"\(goal.goalTitle!)\" have been completed. If you have finished, press 'Celebrate it!' If you still need to continue, press 'Add More Task' and go to Task List view to add more.", preferredStyle: .alert)
            //alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
           
            
            alert.addAction(UIAlertAction(title: "Not Done Yet, Add More Task", style: .default, handler: {(alert: UIAlertAction!) in
               
               
                self.addMoreTask(goal: goal, indexPath: indexPath)
            }))
                
                
            
            alert.addAction(UIAlertAction(title: "It's Done, Let's Celebrate it!", style: .default, handler: {(alert: UIAlertAction!) in
                
                // Display Congratulation Message and Reward Image
                let congratAlert = UIAlertController(title: "Congratulation!", message: "You now deserve \(goal.goalReward ?? "something you crave")! now. Celebrate your accomplishment with the reward RIGHT NOW!" , preferredStyle: .alert)
                
                let imageView = UIImageView(frame: CGRect(x:150, y:110, width: 150, height: 150))
                
                if let goalRewardImageData = goal.goalRewardImage as Data? {
                    imageView.image = UIImage(data: goalRewardImageData)
                } else {
                    imageView.image = #imageLiteral(resourceName: "PoliPoliFace")
                }

                PlayAudio.sharedInstance.playClick(fileName: "triplebarking", fileExt: ".wav")
                congratAlert.view.addSubview(imageView)
                

                // Change goalDone value
                goal.goalDone = true
                // Declare ManagedObjectContext to save goalDone value
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

                // Save to core data
                do {
                    try context.save()
                    
                }catch{
                    print("Saving Error: \(error)")
                }
                
                
                self.present(congratAlert, animated: true, completion: nil)
                
                // Display congratAlert view for x seconds
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when, execute: {
                    congratAlert.dismiss(animated: true, completion: nil)
                    
                })

            }))

            self.present(alert, animated: true, completion: nil)

        }
        
        
        if goal.goalDone == true {
             // Change background color if goalDone is true
            goalCell.goalDescriptionTextView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
            goalCell.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        } else {
            goalCell.goalDescriptionTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            goalCell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }

        return goalCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "taskList", sender: self)
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let goal = goals[indexPath.row]
       
        let updateAction = UITableViewRowAction(style: .default, title: "Update") { (action, indexPath) in
            // Call update action
            self.updateAction(goal: goal, indexPath: indexPath)
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            // Call delete action
            self.deleteAction(goal: goal, indexPath: indexPath)

        }
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .blue
        return [deleteAction, updateAction]
    }
    
    private func updateAction(goal: Goal, indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if goal.goalDone == false {
            self.performSegue(withIdentifier: "updateGoal", sender: self)
        } else {
            self.performSegue(withIdentifier: "toGoalDone", sender: self)
        }

        self.fetchData()
    }
    
    private func deleteAction(goal: Goal, indexPath: IndexPath) {
       // Pop up an alert to warn a user of deletion of data
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            // Declare ManagedObjectContext
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // Delete a row from tableview
            let goalToDelete = self.goals[indexPath.row]
            // Delete it from Core Data
            context.delete(goalToDelete)
            // Save the updated data to Core Data
            do {
                try context.save()
               
                
            } catch {
                print("Saving Failed: \(error)")
            }
            // Fetch the updated data
            self.fetchData()
            
            // Refresh tableView with updated data
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }


   // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "updateGoal" {

            let destVC = segue.destination as! GoalTitleViewController
            let goal = goals[selectedIndex]
            destVC.goal = goal
            destVC.segueName = segue.identifier
            //destVC.userName = userName
            
        } else if segue.identifier == "toGoalDone" {
            let destVC = segue.destination as! GoalDoneViewController
            let goal = goals[selectedIndex]
            destVC.goal = goal
            destVC.userName = userName!
            
        } else if segue.identifier == "taskList" {

            let destVC = segue.destination as! TaskTableViewController
            let goal = goals[selectedIndex]
            destVC.selectedGoal = goal
            //destVC.userName = userName
            

            /*
            let _ = sender as? UITableViewCell,
            let vc = segue.destination as? TaskTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            selectedGoal = goals[(indexPath?.row)!]
            vc.selectedGoal = selectedGoal
             */
            
        } else if segue.identifier == "settingsSegue" {
            let destVC = segue.destination as! SettingsViewController
            destVC.userName = userName

        } else if segue.identifier == "logoutSegue" {
            let destVC = segue.destination as! LoginViewController
            destVC.isOpening = false
            
        } else if segue.identifier == "todaysTasksSegue" {
            _ = segue.destination as! TodaysTasksTableViewController
            
        }
    }
    
}


