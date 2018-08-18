//
//  TaskTableViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 7/17/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData


class TaskTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var tasks = [Task]()
    var selectedGoal: Goal?
    var selectedIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.prompt = "Task List"
        self.navigationItem.title = selectedGoal?.goalTitle

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
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        print("TaskTableVC : selectedGoal :")
        print(selectedGoal)
        if selectedGoal != nil {
            // Predicate with Relationship data
            fetchRequest.predicate = NSPredicate(format: "goalAssigned.goalTitle = %@", (selectedGoal?.goalTitle)!)
            
            // Declare sort descriptor
            let sortByDone = NSSortDescriptor(key: #keyPath(Task.isDone), ascending: true)
            let sortByDate = NSSortDescriptor(key: #keyPath(Task.date), ascending: true)
            let sortByToDo = NSSortDescriptor(key: #keyPath(Task.toDo), ascending: true)
            // Sort fetchRequest array data
            fetchRequest.sortDescriptors = [sortByDone, sortByDate, sortByToDo]
            
            do {
                tasks = try context.fetch(fetchRequest)
                
            } catch {
                print(error)
            }
        }else{
            print("selectedGoal error: \(selectedGoal)")
        }
    }
    
    func goalDoneAlert() {

        AlertNotification().alert(title: "Goal Already Done", message: "Unable to change task data. To enable task data editing, go back to Goal List view and use Update to change the goal's done status to Undone.", sender: self)
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath)

        // Configure the cell...
        let task = tasks[indexPath.row]
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: (task.date)! as Date)
        
        taskCell.detailTextLabel?.text = dateString
        
        if task.isDone == true {
            taskCell.accessoryType = UITableViewCellAccessoryType.checkmark
            taskCell.detailTextLabel?.textColor = .black
        } else  {
            taskCell.accessoryType = UITableViewCellAccessoryType.none
            
            let today = Date()
            let evaluate = NSCalendar.current.compare(task.date! as Date, to: today, toGranularity: .day)
            
            switch evaluate {
            // If task date is today, display it in purple
            case ComparisonResult.orderedSame :
                taskCell.detailTextLabel?.textColor = .purple
            // If task date passed today, display it in red
            case ComparisonResult.orderedAscending :
                taskCell.detailTextLabel?.textColor = .red
            default:
                taskCell.detailTextLabel?.textColor = .black
            }
            
        }
        
        
        if task.isImportant == true {
            taskCell.textLabel?.text = "🍖 \(task.toDo!)"
            
        } else {
            taskCell.textLabel?.text = task.toDo
        }

        return taskCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = tasks[indexPath.row]
        
        if task.goalAssigned?.goalDone == true {
            goalDoneAlert()
            
            
        } else if task.goalAssigned?.goalDone == false {
            // checkmark on select
            if let taskCell = tableView.cellForRow(at: indexPath) {
                
                if taskCell.accessoryType == .checkmark {
                    taskCell.accessoryType = .none
                    task.isDone = false
                    PlayAudio.sharedInstance.playClick(fileName: "whining", fileExt: ".wav")
                    
                    
                }else {
                    taskCell.accessoryType = .checkmark
                    task.isDone = true
                    PlayAudio.sharedInstance.playClick(fileName: "smallbark", fileExt: ".wav")
                    
                    
                    
                    //AlertNotification().alert(title: "You Did it!", message: "Good Job! You completed a task, \"\(task.toDo!)\".", sender: self)
                    
                }
            }
            do {
                try context.save()
                
            } catch {
                print("Cannot save object: \(error)")
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = tasks[indexPath.row]
        
        let updateAction = UITableViewRowAction(style: .default, title: "Update") { (action, indexPath) in
            if task.goalAssigned?.goalDone == true {
                self.goalDoneAlert()
                
            } else {
                // Call update action
                self.updateAction(task: task, indexPath: indexPath)
            }
            
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if task.goalAssigned?.goalDone == true {
                self.goalDoneAlert()
                
            } else {
            // Call delete action
            self.deleteAction(task: task, indexPath: indexPath)
            }
        }
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .blue
        return [deleteAction, updateAction]
    }
    
    private func updateAction(task: Task, indexPath: IndexPath) {
    
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "updateTask", sender: self)
    }
    
    private func deleteAction(task: Task, indexPath: IndexPath) {
        // Pop up an alert to warn a user of deletion of data
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            // Declare ManagedObjectContext
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // Delete a row from tableview
            let taskToDelete = self.tasks[indexPath.row]
            // Delete it from Core Data
            context.delete(taskToDelete)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addTask" {

            if selectedGoal?.goalDone == true {
                self.goalDoneAlert()
                
            } else {
                let destVC = segue.destination as! TaskViewController
                destVC.selectedGoal = selectedGoal
                destVC.segueName = "addTask"
            }
    
        } else if segue.identifier == "updateTask" {
            
            let destVC = segue.destination as! TaskViewController
            let selectedTask = tasks[selectedIndex]
            destVC.selectedTask = selectedTask
            destVC.segueName = "updateTask"
        }
    }

}
