//
//  NotificationsVC.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import Firebase

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
     // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var myMeetsButton: UIButton!
    
    var notifications = [InviteNotification]()
    let getMyNotifications = MyNotifications()
    var meetups = [MeetUp]()
    var statusList = [String]()
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyNotifications.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getMyNotifications.getMyNotifications()
        
        self.tableView.separatorStyle = .none
        
    }
    
    // MARK: - objc Functions
    
    @objc func refreshTable() {

        self.notifications.removeAll()
           
    }
    
    @objc func meetupDeleted() {

        self.notifications.removeAll()
        self.tableView.reloadData()
        
    }
    
    @IBAction func closeButton() {
        
        dismiss(animated: true, completion: nil)
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getMyNotifications.myNotifications.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell : NotificationsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsCell
            
        let text = NSMutableAttributedString()
        
        text.append(NSAttributedString(string: getMyNotifications.myNotifications[indexPath.row].createdBy, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "appBlue")!,NSAttributedString.Key.font: UIFont(name: "Futura", size: 15.0)!]))
        
        text.append(NSAttributedString(string: " invited you to ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont(name: "Futura", size: 15.0)!]))
        
        text.append(NSAttributedString(string: getMyNotifications.myNotifications[indexPath.row].meetupTitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "appBlue")!,NSAttributedString.Key.font: UIFont(name: "Futura", size: 15.0)!]))
        
        cell.notificationString.attributedText = text
        cell.notificationString.lineBreakMode = .byWordWrapping
        cell.iconButton.setImage(UIImage(named: "\(getMyNotifications.myNotifications[indexPath.row].type!).png"), for: .normal)
        
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

            if tableView.cellForRow(at: indexPath as IndexPath) != nil {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                let vc = storyboard.instantiateViewController(withIdentifier: "meetUpVC") as! MeetUpVC

                    vc.modalPresentationStyle = .pageSheet

                    Constants.ref.child("meetups").child(getMyNotifications.myNotifications[indexPath.row].meetupID).observeSingleEvent(of: .value, with: { snapshot in
                                
                                if ( snapshot.value is NSNull ) {
                                    print("- - - No Data was found – – –")
                                   
                                } else {
                                   
                                    guard let dict = snapshot.value as? [String:Any] else {
                                        print("Error")
                                        return
                                    }
                                    
                                       let addressDict = dict["address"] as? [String: Any] ?? [:]
                                           let address = (addressDict["address"] as! String)
                                           let latitude = (addressDict["latitude"] as! String)
                                           let longitude = (addressDict["longitude"] as! String)
                                           let place = (addressDict["place"] as! String)
                                           let rating = (addressDict["rating"] as! String)
                                           let phoneNumber = (addressDict["phoneNumber"] as! String)
                                           let types = (addressDict["types"] as! String)
                                       
                                       let buddyCount = dict["buddyCount"] as? Int
                                       let buddies = dict["buddies"] as! NSArray
                                       let buddiesID = dict["buddiesID"] as? NSArray
                                        
                                       let statusDict = dict["status"] as? [String: Any] ?? [:]
                                           self.statusList = Array(statusDict.values) as! [String]
                                
                                        let date = dict["date"] as! [String: Any]
                                            let shortTimestamp = (date["shortTimestamp"] as! Double)
                                            let longTimestamp = (date["longTimestamp"] as! Double)
                                                                  
                                           
                                       let emoji = dict["emoji"] as? String
                                       let createdAt = dict["createdAt"] as? Double
                                       let organiserName = dict["organiserName"] as? String
                                       let meetupID = dict["meetupID"] as? String
                                       let meetupTitle = dict["meetupTitle"] as? String
                                       let organisedBy = dict["organiserID"] as? String
                                    
                                    self.meetups.append(MeetUp(
                                        shortTimestamp: shortTimestamp,
                                        longTimestamp: longTimestamp,
                                        buddiesArray: buddies as! [String],
                                        address: address,
                                        place: place,
                                        rating: rating,
                                        longitude: longitude,
                                        latitude: latitude,
                                        phoneNumber: phoneNumber,
                                        types: types,
                                        createdAt: createdAt!,
                                        buddyCount: buddyCount!,
                                        emoji: emoji!,
                                        buddiesIDArray: buddiesID! as! [String],
                                        organiserName: organiserName!,
                                        meetupID: meetupID!,
                                        status: self.statusList,
                                        meetupTitle: meetupTitle!,
                                        organisedBy: organisedBy!
                                    ))
                                       
                        }
                                     DispatchQueue.main.async {
                                   
                                        vc.buddiesArray = self.meetups[indexPath.row].buddiesArray
                                        vc.statusArray = self.meetups[indexPath.row].status
                                        vc.timeStamp = self.meetups[indexPath.row].longTimestamp
                                        vc.locationTitle = self.meetups[indexPath.row].place
                                        vc.meetupTitle = self.meetups[indexPath.row].meetupTitle
                                        vc.emojiTitle = self.meetups[indexPath.row].emoji
                                        vc.buddyCount = self.meetups[indexPath.row].buddiesArray.count
                                        vc.meetupID = self.meetups[indexPath.row].meetupID
                                        vc.organiserString = self.meetups[indexPath.row].organiserName
                                        vc.address = self.meetups[indexPath.row].address
                                        vc.rating = self.meetups[indexPath.row].rating
                                        vc.latitude = self.meetups[indexPath.row].latitude
                                        vc.longitude = self.meetups[indexPath.row].longitude
                                        vc.phoneNumber = self.meetups[indexPath.row].phoneNumber
                                        vc.isMyMeetup = false
                                        self.present(vc, animated: true, completion: nil)
}

})
}
}
}


