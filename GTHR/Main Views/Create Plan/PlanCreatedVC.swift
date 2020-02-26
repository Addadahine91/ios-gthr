//
//  PlanCreatedVC.swift
//  GTHR
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets

class PlanCreatedVC: UIViewController {
    
    
    // MARK: - IBOutlets

    @IBOutlet var updateButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var meetupTitleLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    // MARK: - Class Properties
    
    var firstName: String! = ""
    var buddiesArray = [String]()
    var buddiesID2 = [String]()
    var buddiesArray2 = [String]()
    var statusArray = [String]()
    var meetupID: String! = ""
    var latitude: String!
    var longitude: String!
    var address: String!
    var rating: String!
    var phoneNumber: String!
    var types: String!
    var organiserString: String?
    var timeStamp: Double?
    var locationTitle: String?
    var meetupTitle: String?
    var emojiTitle: String?
    var buddyCount: Int!
    var isMyMeetup: Bool = false
    var myIndex = 0
    
    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton.setTitle("My Plans", for: .normal)
        deleteButton.setTitle("This Plan", for: .normal)
        updateButton.backgroundColor = UIColor.init(named: "appBlue")
        deleteButton.backgroundColor = UIColor.init(named: "appGreen")
        updateButton.alpha = 1
        deleteButton.alpha = 1
        
        [updateButton,deleteButton].forEach {
            $0?.layer.cornerRadius = 15
        }
       
        meetupTitleLabel.text = meetupTitle!
        emojiLabel.text = emojiTitle!
        
    }
    
    // MARK: - IBActions
    @IBAction func closeAction() {


    }
    
    @IBAction func myPlansAction() {
            
        self.showVC(vcString: "mymeetupsVC", storyboard: "Main", style: .fullScreen)
        
    }
          
    @IBAction func thisPlanAction() {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "meetUpVC") as! MeetUpVC

            vc.timeStamp = UserDefaults.standard.double(forKey: "longTimestamp")
            vc.locationTitle = UserDefaults.standard.string(forKey: "location")
            vc.meetupTitle = UserDefaults.standard.string(forKey:"planName")!
            vc.emojiTitle = UserDefaults.standard.string(forKey: "emoji")
            vc.buddiesArray = UserDefaults.standard.stringArray(forKey: "buddiesSelected") ?? [String]()
            vc.buddyCount = UserDefaults.standard.integer(forKey:"buddies")
            vc.organiserString = Constants.fullName
            vc.statusArray = UserDefaults.standard.stringArray(forKey: "statusArray") ?? [String]()
            vc.meetupID = self.meetupID
            vc.latitude = UserDefaults.standard.string(forKey: "latitude")
            vc.longitude = UserDefaults.standard.string(forKey: "longitude")
            vc.address = UserDefaults.standard.string(forKey: "address")
            vc.rating = UserDefaults.standard.string(forKey: "rating")
            vc.phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
            vc.types = UserDefaults.standard.string(forKey: "types")
            vc.isMyMeetup = true
            NotificationCenter.default.post(name: .getUpcomingMeetup, object: nil)
            self.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - objc Functions
    
}

