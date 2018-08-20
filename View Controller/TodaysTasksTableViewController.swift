//
//  TodaysTasksTableViewController.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/16/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class TodaysTasksTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var tasks = [Task]()
    var selectedGoal: Goal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.prompt = "Task List"
        self.navigationItem.title = "Today's Tasks To-Do"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

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
        
        //var taskDate = Task.date
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
//        let todayPredicate = NSPredicate(format: "date >= %@ AND date < %@", dateFrom as CVarArg, dateTo! as CVarArg)
        let todayPredicate = NSPredicate(format: "date < %@", dateTo! as CVarArg)

        let donePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [todayPredicate, donePredicate])
        
        fetchRequest.predicate = andPredicate
        
        
        // Declare sort descriptor
        let sortByGoalAssigned = NSSortDescriptor(key: #keyPath(Task.goalAssigned), ascending: true)
        let sortByToDo = NSSortDescriptor(key: #keyPath(Task.toDo), ascending: true)
        
//        let sortByDone = NSSortDescriptor(key: #keyPath(Task.isDone), ascending: true)
        let sortByDate = NSSortDescriptor(key: #keyPath(Task.date), ascending: true)
        
        // Sort fetchRequest array data
        fetchRequest.sortDescriptors = [sortByGoalAssigned, sortByDate, sortByToDo]
        
        do {
            tasks = try context.fetch(fetchRequest)
            //print(tasks)
            
            
        } catch {
            print(error)
        }
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.toDo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: (task.date)! as Date)
       
        if let goalTitle = task.goalAssigned?.goalTitle {
            cell.detailTextLabel?.text =  "\(dateString) : \(goalTitle)"
        }else{
            cell.detailTextLabel?.text =  dateString
        }
    
        
        let today = Date()
        let evaluate = NSCalendar.current.compare(task.date! as Date, to: today, toGranularity: .day)
        
        switch evaluate {
        // If task date is today, display it in purple
        case ComparisonResult.orderedSame :
            cell.detailTextLabel?.textColor = .purple
        // If task date passed today, display it in red
        case ComparisonResult.orderedAscending :
            cell.detailTextLabel?.textColor = .red
        default:
            cell.detailTextLabel?.textColor = .black
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTaskList", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskList" {
            if let vc = segue.destination as? TaskTableViewController {
                
                let indexPath = self.tableView.indexPathForSelectedRow
                selectedGoal = tasks[(indexPath?.row)!].goalAssigned //goals[(indexPath?.row)!]
                
                vc.selectedGoal = selectedGoal
            }
        }
    }


}
