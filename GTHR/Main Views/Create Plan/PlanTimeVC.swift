//
//  PlanTimeVC.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector
import GooglePlaces
import Firebase

class PlanTimeVC: UIViewController, WWCalendarTimeSelectorProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet var emojiButton: UIButton!
    @IBOutlet var emojiView: UIView!
    @IBOutlet var timeView: UIView!
    @IBOutlet var friendsView: UIView!
    @IBOutlet var locationView: UIView!
    @IBOutlet var timeButton: UIButton!
    @IBOutlet var friendsButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var planNameLabel: UILabel!
    @IBOutlet var finishButton: UIButton!
    
    // MARK: - Variables
    
    var meetupID: String!
    var alertViewController: UIAlertController!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onBuddiesPicked), name: .onBuddiesPicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLocationPicked), name: .onLocationPicked, object: nil)
        
        finishButton.alpha = 0.8
        finishButton.isEnabled = false
        
        planNameLabel.text = UserDefaults.standard.string(forKey: "planName")
        emojiButton.setTitle(UserDefaults.standard.string(forKey: "emoji"), for: .normal)
        
        [timeButton,friendsButton,locationButton].forEach {
            $0.titleLabel?.textAlignment = NSTextAlignment.left
            
        }
               
        [locationView,timeView,friendsView,finishButton].forEach {
            $0?.layer.cornerRadius = 20
            
        }
    }
   
    // MARK: - IBActions
    
    @IBAction func finishAction() {
        
        let currentTime = Date().toMillis()
        let shortTimeStamp = UserDefaults.standard.double(forKey: "shortTimeStamp")
        let longTimeStamp = UserDefaults.standard.double(forKey: "longTimeStamp")
        let location = UserDefaults.standard.string(forKey: "location")
        let address = UserDefaults.standard.string(forKey: "address")
        let latitude = UserDefaults.standard.string(forKey: "latitude")
        let longitude = UserDefaults.standard.string(forKey: "longitude")
        let rating = UserDefaults.standard.string(forKey: "rating")
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
        let types = UserDefaults.standard.string(forKey: "types")
        
        let emoji = UserDefaults.standard.string(forKey: "emoji")
        let organiser = Constants.fullName
                  
        let buddiesArray = UserDefaults.standard.stringArray(forKey: "buddiesSelected") ?? [String]()
        let buddiesIDArray = UserDefaults.standard.stringArray(forKey: "buddiesIDSelected") ?? [String]()
        let buddiesID2Array = UserDefaults.standard.stringArray(forKey: "buddiesID2Selected") ?? [String]()
        let buddiesID3Array = UserDefaults.standard.stringArray(forKey: "buddiesID3Selected") ?? [String]()
        let buddiesFCMArray = UserDefaults.standard.stringArray(forKey: "buddiesFCMSelected") ?? [String]()
        
        meetupID = Constants.ref.child("meetups").child(Constants.userUid).childByAutoId().key
                     
            let addressData: [String : Any] = [
                "latitude" : latitude ?? "",
                "longitude" : longitude ?? "",
                "address" : address ?? "",
                "place" : location ?? "",
                "rating" : rating ?? "",
                "phoneNumber" : phoneNumber ?? "",
                "types" : types ?? ""
                ]
                  
            let dateData: [String : Any] = [
                "shortTimestamp" : shortTimeStamp,
                "longTimestamp" : longTimeStamp
                ]
                  
            let recipeJSON: [String : Any] = [
                "date" : dateData,
                "address" : addressData,
                "buddies":  buddiesArray,
                "buddiesID":  buddiesIDArray,
                "buddiesFCM":  buddiesFCMArray,
                "createdAt":  currentTime!,
                "buddyCount" : buddiesArray.count,
                "emoji" : emoji!,
                "organiserName" : organiser,
                "organiserID" : Constants.userUid,
                "meetupID" : meetupID!,
                "meetupTitle" : UserDefaults.standard.string(forKey:"planName")!
                ]
                  
            Constants.ref.child("meetups").child(meetupID).updateChildValues(recipeJSON)

            for buddyID in buddiesID2Array {
               
               let data: [String : Any] = [buddyID: true]
               
               Constants.ref.child("meetups").child(meetupID).child("buddiesID2").updateChildValues(data)
               Constants.ref.child("meetups").child(meetupID).child("status").updateChildValues([buddyID: "Waiting..."])
               Constants.ref.child("notifications").child(meetupID).child("received").updateChildValues([buddyID: true])
               
           }
        
            for buddyID in buddiesID3Array {
            
            let data: [String : Any] = [buddyID: true]
            
            Constants.ref.child("meetups").child(meetupID).child("buddiesID3").updateChildValues(data)
            
            }
           
           for FCM in buddiesFCMArray {
               
               let sender = PushNotificationSender()
               sender.sendPushNotification(to: FCM, title: emoji!, body: "You have a new invite!")
              
           }
        
        let notifJSON: [String : Any] = [
            "notificationType": "invitation",
            "createdBy": Constants.firstName,
            "createdByID": Constants.userUid,
            "createdAt":  currentTime!,
            "meetupTitle" : UserDefaults.standard.string(forKey:"planName")!,
            "meetupID" : meetupID!
            ]
        
        Constants.ref.child("notifications").child(meetupID).updateChildValues(notifJSON)
           
            let storyboard = UIStoryboard(name: "CreatePlan", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "planCreatedVC") as! PlanCreatedVC
        
            vc.timeStamp = UserDefaults.standard.double(forKey: "longTimestamp")
            vc.locationTitle = UserDefaults.standard.string(forKey: "location")
            vc.meetupTitle = UserDefaults.standard.string(forKey:"planName")!
            vc.emojiTitle = UserDefaults.standard.string(forKey: "emoji")
            vc.buddiesArray = UserDefaults.standard.stringArray(forKey: "buddiesSelected") ?? [String]()
            vc.buddyCount = UserDefaults.standard.integer(forKey:"buddies")
            vc.organiserString = organiser
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
    
    @IBAction func timeAction() {
        
        alertViewController = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)

        alertViewController.addAction(UIAlertAction(title: "I have a date in mind", style: UIAlertAction.Style.default)
        { action -> Void in
            self.datePicker()
        })
        alertViewController.addAction(UIAlertAction(title: "Availability Checker", style: UIAlertAction.Style.default)
        { action -> Void in
           
            self.showVC(vcString: "timeFrameVC", storyboard: "CreatePlan", style: .pageSheet)
            
        })
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
                       
        }))
        self.present(alertViewController, animated: true, completion: nil)

    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            UserDefaults.standard.set("Unknown", forKey: "journey")
            self.showVC(vcString: "planNameVC", storyboard: "CreatePlan", style: .pageSheet)
                        
        } else {
            
            UserDefaults.standard.set("Known", forKey: "journey")
            self.showVC(vcString: "planNameVC", storyboard: "CreatePlan", style: .pageSheet)
            
        }
        
        
    }
    
    @IBAction func pickLocation(sender: UIButton) {
               
        self.showVC(vcString: "locationVC", storyboard: "CreatePlan", style: .pageSheet)
        
    }
    
    // MARK: - @objc Functions
    
    @objc func onLocationPicked() {
        
        let placeName = UserDefaults.standard.string(forKey: "location")
        
        friendsButton.isEnabled = true
        self.locationButton.setTitle(placeName, for: .normal)
        self.locationButton.setTitleColor(.black, for: .normal)
        
    }
    
    @objc func onBuddiesPicked() {
          
           let buddyString = UserDefaults.standard.integer(forKey:"buddies")
        
           if buddyString == 1 {
               
               self.friendsButton.setTitle("\(UserDefaults.standard.integer(forKey:"buddies"))" + " buddy", for: .normal)
               
           } else {
               
              self.friendsButton.setTitle("\(UserDefaults.standard.integer(forKey:"buddies"))" + " buddies", for: .normal)
           }
             
               self.friendsButton.setTitleColor(.black, for: .normal)
               self.friendsButton.setTitleColor(.black, for: .normal)
           
        timeButton.isEnabled = true
        locationButton.isEnabled = true
        friendsButton.isEnabled = true
        finishButton.isEnabled = true
        finishButton.alpha = 1
        
    }
    
    // MARK: - Functions
    
    func datePicker() {
         
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionTopPanelBackgroundColor = UIColor.init(named: "appRed")!
        selector.optionSelectorPanelBackgroundColor = UIColor.init(named: "appRed")!
        selector.optionCalendarFontColorPastDates = .lightGray
         
         selector.optionTopPanelFont = UIFont(name: "Futura", size: 17.0)!
        
         selector.optionClockFontAMPM = UIFont(name: "Futura", size: 15.0)!
         selector.optionClockFontAMPMHighlight = UIFont(name: "Futura", size: 17.0)!
         
         selector.optionClockFontHour = UIFont(name: "Futura", size: 15.0)!
         selector.optionClockFontHourHighlight = UIFont(name: "Futura", size: 17.0)!
         
         selector.optionClockFontMinute = UIFont(name: "Futura", size: 15.0)!
         selector.optionClockFontMinuteHighlight = UIFont(name: "Futura", size: 17.0)!
         
         selector.optionButtonFontDone = UIFont(name: "Futura", size: 15.0)!
         selector.optionButtonFontCancel = UIFont(name: "Futura", size: 15.0)!
         
         selector.optionSelectorPanelFontTime = UIFont(name: "Futura", size: 18.0)!
         
         present(selector, animated: true, completion: nil)
        
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a EEE d MMM"
        
        self.timeButton.setTitle(dateFormatter.string(from: date), for: .normal)
        self.timeButton.setTitleColor(.black, for: .normal)
                   
        let shortTimeInterval = floor(date.timeIntervalSinceReferenceDate / 86400) * 86400
        let shortDate = Date(timeIntervalSinceReferenceDate: shortTimeInterval)
       
        let shortTimestamp = shortDate.timeIntervalSince1970
        let longTimestamp = date.timeIntervalSince1970

        UserDefaults.standard.set(shortTimestamp, forKey: "shortTimestamp")
        UserDefaults.standard.set(longTimestamp, forKey: "longTimestamp")
        
        timeButton.isEnabled = true
        locationButton.isEnabled = true
        friendsButton.isEnabled = false
               
    }
    
}

extension PlanTimeVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
        self.locationButton.setTitle(place.name!, for: .normal)
        self.locationButton.setTitleColor(.black, for: .normal)
        UserDefaults.standard.set(place.name!, forKey: "location")
        UserDefaults.standard.set(place.formattedAddress!, forKey: "address")
        UserDefaults.standard.set(place.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(place.coordinate.longitude, forKey: "longitude")
        UserDefaults.standard.set(place.rating, forKey: "rating")
        UserDefaults.standard.set(place.website, forKey: "website")
        UserDefaults.standard.set(place.phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.set(place.types, forKey: "types")
        friendsButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }

}
