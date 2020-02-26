//
//  DayViewController.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
     // MARK: - IBOutlets
    
    @IBOutlet var noPlansView: UIView!
    @IBOutlet var noMeetups: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var myMeetsButton: UIButton!
    
    @IBOutlet var createNewPlan: UIView!
    
    var meetups = [MeetUp]()
    var statusList = [String]()
    
    var todayTimeStamp: Double!
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date(timeIntervalSince1970: todayTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM"
        
        myMeetsButton.setTitle(dateFormatter.string(from: date), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(meetupDeleted), name:NSNotification.Name(rawValue: "meetupDeleted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name:NSNotification.Name(rawValue: "NotificationID2"), object: nil)
    
        noPlansView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        createNewPlan.layer.addSublayer(dashRect().dashRectFunction(roundedView: createNewPlan))

        tableView.register(UINib(nibName: "MyMeetUpCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getMeetups()
        
        self.tableView.separatorStyle = .none
        
    }
    
    // MARK: - objc Functions
    
    @objc func refreshTable() {

        self.meetups.removeAll()

        getMeetups()
           
       }
    
    @IBAction func createEvent() {
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "createPlanTest") as! CreatePlanTest
            vc.todayTimestamp = self.todayTimeStamp
            self.present(vc, animated: true, completion: nil)
            NotificationCenter.default.post(name: .openTimePicker, object: nil)
        }
        
    }
    @objc func meetupDeleted() {

        self.meetups.removeAll()
        self.tableView.reloadData()
        getMeetups()
        
    }
    
    @IBAction func closeButton() {
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func getMeetups() {
        
        Constants.ref.child("meetups").queryOrdered(byChild: "buddiesID3/\(Constants.userUid)").queryEqual(toValue: true).observeSingleEvent(of: .value, with: { snapshot in
                 if ( snapshot.value is NSNull ) {
                    
                     print("– – – Data was not found – – –")

                    
                 } else {
                    
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let dictValue = snap.value as! [String: Any]
                        let addressDict = dictValue["address"] as? [String: Any] ?? [:]
                            let address = (addressDict["address"] as! String)
                            let latitude = (addressDict["latitude"] as! String)
                            let longitude = (addressDict["longitude"] as! String)
                            let place = (addressDict["place"] as! String)
                            let rating = (addressDict["rating"] as! String)
                            let phoneNumber = (addressDict["phoneNumber"] as! String)
                            let types = (addressDict["types"] as! String)

                            
                        let buddyCount = dictValue["buddyCount"] as? Int
                        let buddies = dictValue["buddies"] as! NSArray
                        let buddiesID = dictValue["buddiesID"] as? NSArray
                        
                        let status = dictValue["status"] as? [String: Any] ?? [:]
                        
                    for statusData in status {
                            
                        if let statusString = statusData.value as? String {
                                    
                            self.statusList.append(statusString)
                            
                        }
                    }
                        
                let date = dictValue["date"] as! [String: Any]
                    let shortTimestamp = (date["shortTimestamp"] as! Double)
                    let longTimestamp = (date["longTimestamp"] as! Double)
                            
                let emoji = dictValue["emoji"] as? String
                let createdAt = dictValue["createdAt"] as? Double
                let organiserName = dictValue["organiserName"] as? String
                let meetupID = dictValue["meetupID"] as? String
                let meetupTitle = dictValue["meetupTitle"] as? String
                let organisedBy = dictValue["organiserID"] as? String
                        
                    self.meetups.append(MeetUp(shortTimestamp: shortTimestamp, longTimestamp: longTimestamp, buddiesArray: buddies as! [String], address: address, place: place, rating: rating, longitude: longitude, latitude: latitude, phoneNumber: phoneNumber, types: types, createdAt: createdAt!, buddyCount: buddyCount!, emoji: emoji!, buddiesIDArray: buddiesID! as! [String], organiserName: organiserName!, meetupID: meetupID!, status: self.statusList,meetupTitle: meetupTitle!, organisedBy: organisedBy!))
                        
                self.meetups = self.meetups.filter { $0.shortTimestamp! == self.todayTimeStamp! }
                self.meetups.sort { $0.shortTimestamp < $1.shortTimestamp }
                        
            }
                    
                        DispatchQueue.main.async {
        
                            self.tableView.reloadData()
        
                        }
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if meetups.count == 0 {

            noPlansView.isHidden = false
            
        } else {
            
            noPlansView.isHidden = true
            
        }
        
        return meetups.count
        
}
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = Date(timeIntervalSince1970: meetups[indexPath.row].longTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
           
        let cell : MyMeetUpCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyMeetUpCell
            
            cell.placeLabel.text = meetups[indexPath.row].place
            cell.dateLabel.text = dateFormatter.string(from: date)
            cell.addressLabel.text = meetups[indexPath.row].address
            cell.emojiButton.setTitle(meetups[indexPath.row].emoji, for: .normal)
            cell.meetupID = meetups[indexPath.row].meetupID
            cell.meetupTitleLabel.text = meetups[indexPath.row].meetupTitle
        
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
           
            if tableView.cellForRow(at: indexPath as IndexPath) != nil {
                      
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                let vc = storyboard.instantiateViewController(withIdentifier: "meetUpVC") as! MeetUpVC
                    
                    vc.modalPresentationStyle = .pageSheet
                    vc.buddiesArray = meetups[indexPath.row].buddiesArray
                    vc.statusArray = meetups[indexPath.row].status
                    vc.timeStamp = meetups[indexPath.row].longTimestamp
                    vc.locationTitle = meetups[indexPath.row].place
                    vc.meetupTitle = meetups[indexPath.row].meetupTitle
                    vc.emojiTitle = meetups[indexPath.row].emoji
                    vc.buddyCount = meetups[indexPath.row].buddiesArray.count
                    vc.meetupID = meetups[indexPath.row].meetupID
                    vc.organiserString = meetups[indexPath.row].organiserName
                    vc.address = meetups[indexPath.row].address
                    vc.rating = meetups[indexPath.row].rating
                    vc.latitude = meetups[indexPath.row].latitude
                    vc.longitude = meetups[indexPath.row].longitude
                    vc.phoneNumber = meetups[indexPath.row].phoneNumber

                    if self.meetups[indexPath.row].organisedBy == Constants.userUid {
                        
                        vc.isMyMeetup = true
                        
                    } else {
                        
                         vc.isMyMeetup = false
                    }
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }
        }

    }


