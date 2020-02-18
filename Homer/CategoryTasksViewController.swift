//
//  CategoryTasksViewController.swift
//  Homer
//
//  Created by Alfredo Giuliano on 17/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit

class CategoryTasksViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment!.selectedSegmentIndex==0{
            return allTasks.count
        }
        else{
            return disabledTasks.count
        }
        //            return NStasks!.count
    }
    
    

//    riempimento e riutilizzo celle
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categoryTasksCell", for: indexPath) as! CategoryTasksCell
        print("row: \(indexPath.row)")
        let task:Task
        if segment!.selectedSegmentIndex==0{
            task=allTasks[indexPath.row]
        }
        else{
            task=disabledTasks[indexPath.row]
            
        }
        cell.descriptionLabel.text=task.desc
        cell.savingsLabel.text="\(task.savings)$"
        cell.ecoPointsLabel.text="\(task.ecoPoints)EP"
        cell.checkBox.isSelected=task.isChecked()
        cell.checkBox.isHidden=false
        cell.weeklyLabel.isHidden=(!task.weekly)
        cell.enableButton.isHidden=true
        if task.state=="disabled"{
            switchState(cell)
        }
        cell.task=task
        cell.tableView=tableView
        cell.disabledTasks=disabledTasks
        cell.reloadTasks=reloadTasks
        
        return cell
    }
    
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    
//    Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("edit mode!")
        if editingStyle == .delete {
            // Delete the row from the data source
            let task : Task =  allTasks[indexPath.row]
            task.disable()
            tableView.reloadData()

            print("delete!")
        }
    }
    
    
//    Delete funzionante solo per task con stato non "disabled"
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if segment!.selectedSegmentIndex==0{
            let task=allTasks[indexPath.row]
            if task.state=="disabled" {
                return false
            }
            return true
        }
        return false
        
    }
    
    
    var segment: UISegmentedControl?
    var category:String="titolo"
    var allTasks: [Task] = []
    var NStasks:NSSet?
    var disabledTasks: [Task]=[]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let header  = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: header.frame.width-10, height: header.frame.height-10)
        let categoryUppercased:String = category.prefix(1).uppercased() + category.dropFirst()
        label.text = categoryUppercased
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = UIColor(red: 12/255, green: 97/255, blue: 97/255, alpha: 1.0)
        header.addSubview(label)
        tableView.tableHeaderView = header
        

        
        
        
        segment = UISegmentedControl(items: ["All", "Disabled"])
        segment!.sizeToFit()
        segment!.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
        segment!.selectedSegmentIndex = 0;
        segment!.addTarget(self, action: Selector("segmentValueChanged"), for: .valueChanged)
        
        
        self.navigationItem.titleView = segment

        navigationController?.navigationBar.tintColor = UIColor(red: 18/255, green: 148/255, blue: 148/255, alpha: 1.0)


        tableView.delegate = self
        tableView.dataSource = self
        
        reloadTasks()
        
        // Do any additional setup after loading the view.
    }
    
    private func switchState(_ cell:CategoryTasksCell){
        print("switch!")
        cell.checkBox.isHidden=(!cell.checkBox.isHidden)
        cell.enableButton.isHidden=(!cell.enableButton.isHidden)
        
    }
    
    @IBAction func segmentValueChanged(){
        switch segment!.selectedSegmentIndex{
        case 0: print("0")
        reloadTasks()
        tableView.reloadData()
        
        case 1:print("1")
        reloadTasks()
        tableView.reloadData()
        default: print("Error in switch")
        }
        
    }

    func reloadTasks(){
        print("ricarico i task")
        NStasks=PMCategory.fetchByName(name: category)[0].tasks!
        allTasks = []
        disabledTasks = []
        
        for object in NStasks! {
            allTasks.append(object as! Task)
            if allTasks.last?.state=="disabled"{
                disabledTasks.append(object as! Task)
            }
        }
    }
    

    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
