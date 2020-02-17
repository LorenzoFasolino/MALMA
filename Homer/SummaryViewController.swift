//
//  SummaryViewController.swift
//  Homer
//
//  Created by Marco Mannara on 14/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import UIKit
import SceneKit

class SummaryViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var piggyBank: UIImageView!
    @IBOutlet var earth: UIImageView!
    @IBOutlet var ecoPointsText: UILabel!
    @IBOutlet var savingsText: UILabel!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var achievements:[Achievement] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        
        cell.cellImage.image = UIImage(named: achievements[indexPath.row].image!)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    @IBOutlet var achievementCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementCollection.delegate = self
        achievementCollection.dataSource = self
        
        achievements = PMAchievement.fetchAllAchievement()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var ecoPoints:Int32 = 0
        var savings:Float = 0.0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
             ecoPoints  = PMUser.fetchUser().totEcoPoints
             savings = PMUser.fetchUser().totSavings
        case 1:
             ecoPoints  = PMUser.fetchUser().getEcoPointsOfMonth()
             savings = PMUser.fetchUser().getSavingsOfMonth()
        case 2:
             ecoPoints  = PMUser.fetchUser().getEcoPointsOfDay()
             savings = PMUser.fetchUser().getSavingsOfDay()
        default:
            print("Unexpected behaviour")
        }
        
                   
        savingsText.text = "\(savings)$"
        ecoPointsText.text = "\(ecoPoints)EP"
        
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            let ecoPoints  = PMUser.fetchUser().totEcoPoints
            let savings = PMUser.fetchUser().totSavings
            
            savingsText.text = "\(savings)$"
            ecoPointsText.text = "\(ecoPoints)EP"
            
            print("first segment")
            
        case 1:
            let ecoPoints  = PMUser.fetchUser().getEcoPointsOfMonth()
            let savings = PMUser.fetchUser().getSavingsOfMonth()
            
            savingsText.text = "\(savings)$"
            ecoPointsText.text = "\(ecoPoints)EP"
            print("second segment")
        case 2:
            print("third segment")
            let ecoPoints  = PMUser.fetchUser().getEcoPointsOfDay()
            let savings = PMUser.fetchUser().getSavingsOfDay()
                       
            savingsText.text = "\(savings)$"
            ecoPointsText.text = "\(ecoPoints)EP"
            
            
        default:
            print("Unexpected behaviour")
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
