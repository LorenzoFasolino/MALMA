//
//  CategoryTasksCell.swift
//  Homer
//
//  Created by Alfredo Giuliano on 17/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit

import GreenCore

class CategoryTasksCell: UITableViewCell {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var weeklyLabel: UILabel!
    @IBOutlet var savingsLabel: UILabel!
    @IBOutlet var ecoPointsLabel: UILabel!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var enableButton: UIButton!

    var task: Task?
    var tableView: UITableView?
    var disabledTasks: [Task]?
    var reloadTasks: () -> () = {}

    override func awakeFromNib() {
        super.awakeFromNib()

        weeklyLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
        checkBox.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkboxPressed(_ sender: Any) {
        if checkBox.isSelected {
            task?.unCheck(appContext: AppContext.getContext())
        } else {
            task?.check(appContext: AppContext.getContext())
        }
        checkBox.isSelected = (!checkBox.isSelected)
    }

    @IBAction func enablePressed(_ sender: Any) {
        if CategoryTasksViewController.segmentedControlState == 0 {
            checkBox.isHidden = false
            enableButton.isHidden = true
        }
        task?.enable(appContext: AppContext.getContext())
        reloadTasks()
        let indexPath = (tableView?.indexPath(for: self))!
        DispatchQueue.main.async {
            if CategoryTasksViewController.segmentedControlState == 0 {
                self.tableView?.reloadRows(at: [indexPath], with: .right)
            } else {
                self.tableView?.deleteRows(at: [indexPath], with: .right)
            }
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
}
