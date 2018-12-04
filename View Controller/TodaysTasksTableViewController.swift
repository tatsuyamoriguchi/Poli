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
    var userName: String = ""


    @objc func addTapped() {

        var image: UIImage
        var message: String
        var url: URL
   
        image = UIImage(named: "PoliPoliIconLarge")!
        message = "I will complete the following task(s) today :"
        url = URL(string: "http://www.beckos.com")!

        
        var previousGoalTitle: String = ""
        for task in tasks {
            
            let goalTitle = task.goalAssigned?.goalTitle
            let toDo = task.toDo
            
            if goalTitle != previousGoalTitle {
                message.append("\n\nGoal Title: \(goalTitle ?? "ERROR NO GOALTITLE")\n- To Do: \(toDo ?? "ERROR NO TODO")  ")
                previousGoalTitle = goalTitle!
            } else {
                message.append("\n- To Do: \(toDo ?? "ERROR NO TODO") ")
            }
        }
  
        //let activityItems = [message, image, url] as [Any]
        let activityItems = [ActivityItemSource(message: message, image: image, url: url)]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.openInIBooks,
            //UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            //UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
        ]
        
        
        self.present(activityVC, animated: true, completion: nil)
        
        //activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //let NSL_taskList = NSLocalizedString("NSL_taskList", value: "Task List", comment: "")
        //self.navigationItem.prompt = NSL_taskList
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            userName = UserDefaults.standard.string(forKey: "userName")!
            self.navigationItem.prompt = "Login as \(userName)"
        }else {
            self.navigationItem.prompt = "Login Error"
        }
        
       
        let NSL_naviToday = NSLocalizedString("NSL_naviToday", value: "Today's Tasks To-Do", comment: "")
        self.navigationItem.title = NSL_naviToday
 
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
        
        // Display a share button, if any tasks item. If no tasks, segue back to root view
        if tasks.count > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTapped))
            
        } else {
            let noTodaysTaskAlert = UIAlertController(title: "Aelrt", message: "No Today's Task now.", preferredStyle: .alert)
            self.present(noTodaysTaskAlert, animated: true, completion: nil)
            
            // Hide rightBarButtonItem
            navigationItem.rightBarButtonItem = nil
            
            // Display congratAlert view for x seconds
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                noTodaysTaskAlert.dismiss(animated: true, completion: nil)
                
            })
            
            //navigationController!.popToRootViewController(animated: true)
            
        }
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
            
        } catch {
            print(error.localizedDescription)
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
        dateFormatter.dateStyle = .full
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

class ActivityItemSource: NSObject, UIActivityItemSource {

    var message: String!
    var image: UIImage!
    var url: URL!
    
    init(message: String, image: UIImage, url: URL) {
        self.message = message
        self.image = image
        self.url = url
    }

    
    override init() {
        image = UIImage(named: "PoliPoliIconLarge")!
        message = "I will complete the following task(s) today :"
        url = URL(string: "http://www.beckos.com")!
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return message
        // to display Instagram button, return image
        // image: Mail, Message, Notes, Twitter, Instagram, Shared Album, Post to Google Maps, Messenger, LINE, Snapchat, Facebook
        // message: Mail, Message, Notes, Twitter, Messenger, LINE, Facebook, LinkedIn
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    
        switch activityType {
        case UIActivity.ActivityType.postToFacebook:
            return image
        case UIActivity.ActivityType.postToTwitter:
            return message
        case UIActivity.ActivityType.mail:
            return message
        case UIActivity.ActivityType.copyToPasteboard:
            return message
        case UIActivity.ActivityType.markupAsPDF:
            return message
        case UIActivity.ActivityType.message:
            return message
        case UIActivity.ActivityType.postToFlickr:
            return image
        case UIActivity.ActivityType.postToTencentWeibo:
            return message
        case UIActivity.ActivityType.postToVimeo:
            return image
        case UIActivity.ActivityType.print:
            return message
        case UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"):
            return message
        case UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"):
            return message
 
        default:
           return message

            // To post image to Instagram, return image
            // message: Mail, Message, Notes, Twitter, Messenger, LINE, Facebook, LinkedIn(althugh showing an error)
 
         }

    }
}

