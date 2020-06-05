//
//  AchievementDetailViewController.swift
//  Homer
//
//  Created by Marco Mannara on 15/02/2020.
//  Copyright © 2020 Lorenzo Fasolino. All rights reserved.
//

import SceneKit
import UIKit

import GreenCore

class AchievementDetailViewController: UIViewController {
    @IBOutlet var detailSceneView: SCNView!
    @IBOutlet var achievementDesc: UILabel!
    var scene: SCNScene?

    var achievement: Achievement?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let ach = achievement {
            
            scene = SCNScene(named: ach.image!+"Medal.scn")
            navigationItem.title = ach.name
            achievementDesc.text = ach.desc

            if(!ach.unlocked){
                let prizeNode = scene?.rootNode.childNode(withName: "Trophy", recursively: false)
                for mat in prizeNode?.geometry?.materials ?? []{
                    mat.diffuse.contents = UIColor(named: "TotalBlackWhite")
                }
            }
        }

        detailSceneView.allowsCameraControl = true
        detailSceneView.cameraControlConfiguration.allowsTranslation = false
        scene?.background.contents = UIColor(named: "TotalWhiteBlack")
        detailSceneView.scene = scene
        navigationController?.navigationBar.tintColor = UIColor(named: "light-green")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        scene?.background.contents = UIColor(named: "TotalWhiteBlack")
        
        if let ach = achievement {
            navigationItem.title = ach.name
            achievementDesc.text = ach.desc
            
            if(!ach.unlocked){
                let prizeNode = scene?.rootNode.childNode(withName: "Trophy", recursively: false)
                for mat in prizeNode?.geometry?.materials ?? []{
                    mat.diffuse.contents = UIColor(named: "TotalBlackWhite")
                }
            }
        }
    }

    /* /Users/marcodellarocca/Documents/Swift Projects/iOS/MALMA/Homer/CategoryTasks.storyboard
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }

     */
}
