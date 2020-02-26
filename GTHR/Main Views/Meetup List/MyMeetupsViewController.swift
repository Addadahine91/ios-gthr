//
//  MyMeetupsViewController.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets

class MyMeetupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let getMyMeetups = MyMeetups()
    let getMyInvites = MyInvites()
    
    @IBOutlet var noPlansView: UIView!
    
    var invitesSelected = false
    var myMeetupsSelected = true
    
    @IBOutlet var noMeetups: UILabel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var myMeetsButton: UIButton!
    @IBOutlet var invitesButton: UIButton!
    
    @IBOutlet var noInvitesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(meetupDeleted), name:NSNotification.Name(rawValue: "meetupDeleted"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name:NSNotification.Name(rawValue: "NotificationID2"), object: nil)
        
        invitesSelected = false
        myMeetupsSelected = true
        
        getMyMeetups.delegate = self as MyMeetupsDelegate
        getMyInvites.delegate = self
    
        noPlansView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "MyMeetUpCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getMyMeetups.getMyMeetUps()
        
        self.tableView.separatorStyle = .none
        
    }
    
    @objc func refreshTable() {

        self.getMyMeetups.myMeetups.removeAll()
        self.getMyInvites.myInvites.removeAll()

        getMyInvites.getMyInvites()
        getMyMeetups.getMyMeetUps()
           
       }
    
    @objc func meetupDeleted() {

        self.getMyMeetups.myMeetups.removeAll()
        self.getMyInvites.myInvites.removeAll()
        self.tableView.reloadData()
        getMyMeetups.getMyMeetUps()
        getMyInvites.getMyInvites()
        
    }
    
    @IBAction func closeButton() {
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func myLabelAction() {
           
        invitesSelected = false
        myMeetupsSelected = true
        
        self.getMyMeetups.myMeetups.removeAll()
        self.getMyInvites.myInvites.removeAll()
        self.tableView.reloadData()
        
        noInvitesLabel.isHidden = true
        myMeetsButton.setTitleColor(.black, for: .normal)
        invitesButton.setTitleColor(.lightGray, for: .normal)
           
        getMyMeetups.getMyMeetUps()
           
       }
    
    @IBAction func inviteLabelAction() {
              
        invitesSelected = true
        myMeetupsSelected = false
        
        self.getMyMeetups.myMeetups.removeAll()
        self.getMyInvites.myInvites.removeAll()
        self.tableView.reloadData()
        
        noInvitesLabel.isHidden = false
        myMeetsButton.setTitleColor(.lightGray, for: .normal)
        invitesButton.setTitleColor(.black, for: .normal)
        
        getMyInvites.getMyInvites()
        
        }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
    if invitesSelected == false {
        
//        if getMyMeetups.myMeetups.count == 0 {
//
//            noPlansView.isHidden = false
//            noInvitesLabel.text = "You don't have any upcoming plans"
//
//        } else {
//
//            noPlansView.isHidden = true
//
//        }
        
         return getMyMeetups.myMeetups.count
        
    } else {
        
//         if getMyInvites.myInvites.count == 0 {
//
//            noPlansView.isHidden = false
//            noInvitesLabel.text = "You don't have any invites"
//
//         } else {
//
//            noPlansView.isHidden = true
//
//        }
        
         return getMyInvites.myInvites.count
    }
    
}
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyMeetUpCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyMeetUpCell
        
        if invitesSelected ==  false {
            
            let date = Date(timeIntervalSince1970: getMyMeetups.myMeetups[indexPath.row].longTimestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            cell.placeLabel.text = getMyMeetups.myMeetups[indexPath.row].place
            cell.dateLabel.text = dateFormatter.string(from: date)
            cell.addressLabel.text = getMyMeetups.myMeetups[indexPath.row].address
            cell.emojiButton.setTitle(getMyMeetups.myMeetups[indexPath.row].emoji, for: .normal)
            cell.meetupID = getMyMeetups.myMeetups[indexPath.row].meetupID
            cell.meetupTitleLabel.text = getMyMeetups.myMeetups[indexPath.row].meetupTitle
            
        }
        else {
            
            noInvitesLabel.isHidden = true
            
            let date = Date(timeIntervalSince1970: getMyInvites.myInvites[indexPath.row].longTimestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            cell.placeLabel.text = getMyInvites.myInvites[indexPath.row].place
            cell.dateLabel.text = dateFormatter.string(from: date)
            cell.addressLabel.text = getMyInvites.myInvites[indexPath.row].address
            cell.emojiButton.setTitle(getMyInvites.myInvites[indexPath.row].emoji, for: .normal)
            cell.meetupID = getMyInvites.myInvites[indexPath.row].meetupID
            cell.meetupTitleLabel.text = getMyInvites.myInvites[indexPath.row].meetupTitle
        
        }
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
           
            if tableView.cellForRow(at: indexPath as IndexPath) != nil {
                    
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "meetUpVC") as! MeetUpVC
                    
                vc.modalPresentationStyle = .pageSheet
                
                if invitesSelected == false {
                    
                vc.buddiesArray = getMyMeetups.myMeetups[indexPath.row].buddiesArray
                vc.statusArray = getMyMeetups.myMeetups[indexPath.row].status
                vc.timeStamp = getMyMeetups.myMeetups[indexPath.row].longTimestamp
                vc.locationTitle = getMyMeetups.myMeetups[indexPath.row].place
                vc.meetupTitle = getMyMeetups.myMeetups[indexPath.row].meetupTitle
                vc.emojiTitle = getMyMeetups.myMeetups[indexPath.row].emoji
                vc.buddyCount = getMyMeetups.myMeetups[indexPath.row].buddiesArray.count
                vc.meetupID = getMyMeetups.myMeetups[indexPath.row].meetupID
                vc.organiserString = getMyMeetups.myMeetups[indexPath.row].organiserName
                vc.address = getMyMeetups.myMeetups[indexPath.row].address
                vc.rating = getMyMeetups.myMeetups[indexPath.row].rating
                vc.latitude = getMyMeetups.myMeetups[indexPath.row].latitude
                vc.longitude = getMyMeetups.myMeetups[indexPath.row].longitude
                vc.phoneNumber = getMyMeetups.myMeetups[indexPath.row].phoneNumber
                vc.isMyMeetup = true
                self.present(vc, animated: true, completion: nil)
                
                } else {
                      
                vc.buddiesArray = self.getMyInvites.myInvites[indexPath.row].buddiesArray
                vc.statusArray = self.getMyInvites.myInvites[indexPath.row].status
                vc.timeStamp = self.getMyInvites.myInvites[indexPath.row].longTimestamp
                vc.locationTitle = self.getMyInvites.myInvites[indexPath.row].place
                vc.meetupTitle = self.getMyInvites.myInvites[indexPath.row].meetupTitle
                vc.emojiTitle = self.getMyInvites.myInvites[indexPath.row].emoji
                vc.buddyCount = self.getMyInvites.myInvites[indexPath.row].buddiesArray.count
                vc.meetupID = self.getMyInvites.myInvites[indexPath.row].meetupID
                vc.organiserString = self.getMyInvites.myInvites[indexPath.row].organiserName
                vc.address = self.getMyInvites.myInvites[indexPath.row].address
                vc.rating = self.getMyInvites.myInvites[indexPath.row].rating
                vc.latitude = self.getMyInvites.myInvites[indexPath.row].latitude
                vc.longitude = self.getMyInvites.myInvites[indexPath.row].longitude
                vc.phoneNumber = self.getMyInvites.myInvites[indexPath.row].phoneNumber
                vc.isMyMeetup = false
                self.present(vc, animated: true, completion: nil)
                     
                }
        }

}

}

