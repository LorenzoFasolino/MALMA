//
//  TaskCell.swift
//  Homer
//
//  Created by Marco Mannara on 13/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    
    @IBOutlet var CategoryIcon: UIImageView!
    @IBOutlet var EcoPointsText: UILabel!
    @IBOutlet var SavingsText: UILabel!
    @IBOutlet var DescriptionText: UILabel!
    @IBOutlet var CheckButton: UIButton!
    
    var checked = false
    
    var task : Task? {
        willSet{
            if let cellTask = newValue{
                if(cellTask.isChecked()){
                    CategoryIcon.image = cellTask.getIcon(true)
                    CheckButton.isSelected = true
                    checked = true
                }else{
                    CategoryIcon.image = cellTask.getIcon(false)
                    CheckButton.isSelected = false
                    checked = false
                }
                
                EcoPointsText.text = String(cellTask.ecoPoints) + "EP"
                SavingsText.text = String(cellTask.savings) + "$"
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
    
        CheckButton.setImage(UIImage(systemName: "circle"), for: .normal)
        CheckButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        CheckButton.isSelected = false
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
        if(selected){
            toggleCheck()
        }
    }
    
    private func toggleCheck(){
        if(checked){
            task?.unCheck()
            checked = false
        }else{
            task?.check()
            checked = true
        }
        CheckButton.isSelected.toggle()
        completed = !completed
        CategoryIcon.image = task?.getIcon(checked)
    }
}
