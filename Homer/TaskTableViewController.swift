//
//  TaskTableViewController.swift
//  Homer
//
//  Created by Marco Mannara on 13/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit

import GreenCore

class TaskTableViewController: UITableViewController {
    var tasks: [Task] = []
//    NotificationCenter.default.addObserver(self, selector: #selector(self.reciveAchievementNotify(), name: Notification.Name("PremioRicevuto"), object: nil)
    
    @objc
    func reciveAchievementNotify(notification: Notification){
        
        if let dict = notification.userInfo as NSDictionary?{
            if let achievement = dict["achievement"] as? Achievement{
                
                let showAlert = UIAlertController(title: "Congratulations! You unlocked the achievement: \(achievement.name ?? "")", message: nil, preferredStyle: .alert)
                let imageView = UIImageView(frame: CGRect(x: 60, y: 100, width: 150, height: 150))
                imageView.image = achievement.getIcon(saturated: true)
                showAlert.view.addSubview(imageView)
                let height = NSLayoutConstraint(item: showAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
                let width = NSLayoutConstraint(item: showAlert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                showAlert.view.addConstraint(height)
                showAlert.view.addConstraint(width)
                showAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    // your actions here...
                }))
                
                self.present(showAlert, animated: true, completion: nil)
                
            }
            
        }
        
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reciveAchievementNotify(notification:)), name: Notification.Name("PremioRicevuto"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tasks = PMTask.fetchUnselectedTask(true, appContext: AppContext.getContext())
        self.tableView.reloadData()
        
        
        
//        if self.tasks.count == 0 {
//            let title = UILabel(frame: CGRect(x: 0, y: 0, width: 220, height: 10))
//            title.font = UIFont.systemFont(ofSize: 18)
//            title.text = "Hai completato tutti i task!"
//            title.sizeToFit()
//            title.center = self.view.center
//            title.center.y = self.view.center.y
//            title.textAlignment = .center
//            self.view.addSubview(title)
//        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskIconCell", for: indexPath) as! TaskCell
        
        cell.task = self.tasks[indexPath.row]
        cell.WeeklyLabel.isHidden = (!tasks[indexPath.row].weekly)
        cell.CategoryIcon.tag = indexPath.row
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    /*
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     } */
    
    @IBAction func refresh(_ sender: Any) {
        self.tasks = PMTask.fetchUnselectedTask(true, appContext: AppContext.getContext())
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let hideAction = UIContextualAction(style: .normal, title: "Hide") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let task = self.tasks[indexPath.row]
            
            if task.priority >= 0 {
                task.priority = -1
            } else if task.priority > -5, task.priority < 0 {
                task.priority -= 1
            }
            
            self.tasks.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            success(true)
        }
        
        hideAction.backgroundColor = UIColor.orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Disable") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            let task = self.tasks[indexPath.row]
            task.priority = 0
            task.disable(appContext: AppContext.getContext())
            self.tasks.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            success(true)
        }
        deleteAction.backgroundColor = UIColor.red
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, hideAction])
        return config
    }
    
    
    
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
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
        
        let button = sender as! UIButton
        let index = button.tag
        
        switch segue.identifier{
            case "showCategory" :
                
               if  let category = tasks[index].category?.name {
                       let dstview = segue.destination as! CategoryTasksViewController
                      dstview.category=category
                }

              
              default:
                  print(#function)
        }
     }
}
