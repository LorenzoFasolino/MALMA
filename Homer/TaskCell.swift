//
//  TaskCell.swift
//  Homer
//
//  Created by Marco Mannara on 13/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit

import GreenCore

class TaskCell: UITableViewCell {

    
//    @IBOutlet var CategoryIcon: UIImageView!
    
    @IBOutlet var EcoPointsText: UILabel!
    @IBOutlet var SavingsText: UILabel!
    @IBOutlet var DescriptionText: UILabel!
    @IBOutlet var CheckButton: UIButton!
    @IBOutlet var WeeklyLabel: UILabel!
    @IBOutlet var CategoryIcon: UIButton!
    var checked = false
    
    var task : Task? {
        willSet{
            if let cellTask = newValue{
                // print("checked\(cellTask.isChecked())")
                if(cellTask.isChecked(appContext: AppContext.getContext())){
                    CategoryIcon.setImage(cellTask.getIcon(true), for: .normal)
                    CheckButton.isSelected = true
                    checked = true
                }else{
                    CategoryIcon.setImage(cellTask.getIcon(false), for: .normal)
                    CheckButton.isSelected = false
                    checked = false
                }
                
                EcoPointsText.text = String(cellTask.ecoPoints) + "EP"
                SavingsText.text = String(format: "%.2f$", cellTask.savings)
                DescriptionText.text = cellTask.desc
            }
        }
    }
    
    var completed : Bool = false
    
    @IBAction func checkPressed(_ sender: UIButton) {
        toggleCheck()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        WeeklyLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        CheckButton.setImage(UIImage(systemName: "circle"), for: .normal)
        CheckButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        CheckButton.isSelected = false
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
        if(selected){
//            toggleCheck()
        }
    }
    
    private func toggleCheck(){
        print("toggle")
        if(checked){
            task?.unCheck(appContext: AppContext.getContext())
            checked = false
        }else{
            task?.check(appContext: AppContext.getContext())
            checked = true
        }
        CheckButton.isSelected.toggle()
        completed = !completed
        CategoryIcon.setImage(task?.getIcon(checked), for: .normal)
    }
}
