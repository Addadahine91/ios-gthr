//
//  EmojiVC.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import FittedSheets

class EmojiVC: UIViewController {
    
    @IBOutlet var emojiButton: UIButton!
    @IBOutlet var emojiView: UIView!
    
    @IBOutlet var nameView: UIView!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    var meetupTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(emojiPicked), name: .emojiPicked, object: nil)
        
        nameTextfield.text = UserDefaults.standard.string(forKey: "planName")
        emojiButton.setTitle(UserDefaults.standard.string(forKey: "emoji"), for: .normal)
        emojiView.layer.addSublayer(dashRect().dashRectFunction(roundedView: emojiView))
        nextButton.alpha = 0.8
        nextButton.isEnabled = false
        
        [nextButton,nameView].forEach {
            $0?.layer.cornerRadius = 20
        }
        
    }
   
    @objc func emojiPicked() {
        
        emojiButton.setTitle(UserDefaults.standard.string(forKey: "emoji"), for: .normal)
        nextButton.alpha = 1
        nextButton.isEnabled = true
    }
    
    @IBAction func emojiAction() {
        
        let storyboard = UIStoryboard(name: "CreatePlan", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "emojiPickerVC")
                    
        let sheetController = SheetViewController(controller: controller, sizes:[.fullScreen])
        sheetController.topCornersRadius = 20
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.dismissable = false
        self.present(sheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func nextAction() {
        
        self.showVC(vcString: "planTimeVC", storyboard: "CreatePlan", style: .pageSheet)
        
    }
    
}
    
    


