//
//  HomeViewController.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FittedSheets

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet var dayOneButton: UIButton!
    @IBOutlet var dayTwoButton: UIButton!
    @IBOutlet var dayThreeButton: UIButton!
    @IBOutlet var dayFourButton: UIButton!
    @IBOutlet var dayFiveButton: UIButton!
    @IBOutlet var daySixButton: UIButton!
    @IBOutlet var daySevenButton: UIButton!
    @IBOutlet var viewDetailButton: UIButton!
    @IBOutlet var timeIconButton: UIButton!
    @IBOutlet var locationIconButton: UIButton!
    @IBOutlet var emojiLabelUpcoming: UIButton?
    @IBOutlet var createPlanButton: UIButton!
    
    @IBOutlet var titleLabelUpcoming: UILabel?
    @IBOutlet var dateLabelUpcoming: UILabel?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var meetupTitleLabel: UILabel?
    @IBOutlet var locationLabelUpcoming: UILabel?
       
    @IBOutlet var arrowView: UIView!
    @IBOutlet var middleView: UIView!
    @IBOutlet var dayOneView: UIView!
    @IBOutlet var dayTwoView: UIView!
    @IBOutlet var dayThreeView: UIView!
    @IBOutlet var dayFourView: UIView!
    @IBOutlet var dayFiveView: UIView!
    @IBOutlet var daySixView: UIView!
    @IBOutlet var daySevenView: UIView!
    @IBOutlet var noPlansView: UIView!
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Class Properties
    
    var getMyInvites = MyInvites()
    var getMyMeetups = MyMeetups()
    var getUpcomingInvites = UpcomingInvites()
    
    var upcomingMeetup = [MeetUp]()
    var dayOneMeetup = [MeetUp]()
    var dayTwoMeetup = [MeetUp]()
    var dayThreeMeetup = [MeetUp]()
    var dayFourMeetup = [MeetUp]()
    var dayFiveMeetup = [MeetUp]()
    var daySixMeetup = [MeetUp]()
    var daySevenMeetup = [MeetUp]()
    var dayStrings = [Date]()
    let reuseIdentifier = "cell"
    var todayTimeStamp: Double!
    var buddyCountUpcoming: Int!
    var buddyCount: Int! = 0
    var meetupID: String!
    var firstName: String! = ""
    var fullName: String! = ""
    var meetupTitle: String?
    var organiser: String?
    var buddiesList = [String]()
    var statusList = [String]()
    var locationManager = CLLocationManager()
    var searchController: UISearchController?
   
    // MARK: - View Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    if let bundleID = Bundle.main.bundleIdentifier {
           
           UserDefaults.standard.removePersistentDomain(forName: bundleID)
           
           }
    
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
    getMyMeetups.delegate = self as MyMeetupsDelegate
    getMyInvites.delegate = self
    getUpcomingInvites.delegate = self
        
    createPlanButton.layer.cornerRadius = 20
       
    tableView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)

    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    getUpcomingMeetup()
    getMyInvites.getMyInvites()
    getUpcomingInvites.getUpcomingInvites()
        
    arrowView.circleView()
    viewDetailButton.layer.cornerRadius = 8
    middleView.dropShadow()

    NotificationCenter.default.post(name: .pushNotif, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(getUpcomingMeetup), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(getUpcomingMeetup), name: .getUpcomingMeetup, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.pushNotif), name: .pushNotif, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(loggedOut), name: .loggedOut, object: nil)
        
        Constants.ref.child("users").child(Constants.userUid).observeSingleEvent(of: .value, with: {(snapshot) in

        Constants.fullName = ((snapshot.value as! NSDictionary)["name"] as? String ?? "")
        Constants.firstName = ((snapshot.value as! NSDictionary)["first_name"] as? String ?? "")
        Constants.fcm =  ((snapshot.value as! NSDictionary)["FCMtoken"] as? String ?? "")
        
        self.fullName = Constants.fullName
        self.nameLabel.text = String("Hey \(Constants.firstName)")
    })
        
        [timeIconButton,titleLabelUpcoming,locationIconButton,arrowView,noPlansView].forEach {
            $0!.isHidden = true }
        
        [dayOneView,dayTwoView,dayThreeView,dayFourView,dayFiveView,daySixView,daySevenView,middleView].forEach {
            $0?.layer.cornerRadius = 15 }

        [dayOneButton,dayTwoButton,
         dayThreeButton,dayFourButton,dayFiveButton,daySixButton,daySevenButton].forEach {
            $0.titleLabel?.textAlignment = NSTextAlignment.center }
        
    }

    // MARK: - IBActions
    
    @IBAction func createPlanAction() {
       
        if let bundleID = Bundle.main.bundleIdentifier {
        
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
        
        }
        
        self.showVC(vcString: "planNameVC", storyboard: "CreatePlan", style: .pageSheet)
        
    }
        
    @IBAction func seeNextEvent() {

       if let storyboard = self.storyboard {
               
           let vc = storyboard.instantiateViewController(withIdentifier: "meetUpVC") as! MeetUpVC
           vc.modalPresentationStyle = .pageSheet
           vc.timeStamp = self.upcomingMeetup[0].longTimestamp
           vc.locationTitle = self.upcomingMeetup[0].place
           vc.buddiesArray = self.upcomingMeetup[0].buddiesArray
           vc.meetupTitle = self.upcomingMeetup[0].meetupTitle
           vc.emojiTitle = self.upcomingMeetup[0].emoji
           vc.buddyCount = self.upcomingMeetup[0].buddyCount
           vc.statusArray = self.upcomingMeetup[0].status
           vc.organiserString = self.upcomingMeetup[0].organiserName
           vc.meetupID = self.upcomingMeetup[0].meetupID
           vc.latitude = self.upcomingMeetup[0].latitude
           vc.longitude = self.upcomingMeetup[0].longitude
           vc.address = self.upcomingMeetup[0].address
           vc.rating = self.upcomingMeetup[0].rating
           vc.phoneNumber = self.upcomingMeetup[0].phoneNumber
        
            if self.upcomingMeetup[0].organisedBy == Constants.userUid {
                               
                vc.isMyMeetup = true
                               
            } else {
                               
                vc.isMyMeetup = false
            }
                           
           self.present(vc, animated: true, completion: nil)

           }
       }
       
    @IBAction func profileAction() {

        self.showVC(vcString: "settingsVC", storyboard: "Main", style: .fullScreen)
            
    }
    
    @IBAction func notificationsAction() {
            
            self.showVC(vcString: "notificationsVC", storyboard: "Main", style: .fullScreen)
         //self.showVC(vcString: "availabilityVC", storyboard: "CreatePlan", style: .fullScreen)
        
    }

    // MARK: - objc Functions
    
    @objc func getUpcomingMeetup() {

        self.upcomingMeetup.removeAll()
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "EEEE"
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "dd MMM"
            
            let timeInterval = floor(Date().timeIntervalSinceReferenceDate / 86400) * 86400
            let today = Date(timeIntervalSinceReferenceDate: timeInterval)
            todayTimeStamp = today.timeIntervalSince1970

            Constants.ref.child("meetups").queryOrdered(byChild: "buddiesID3/\(Constants.userUid)").queryEqual(toValue: true).observeSingleEvent(of: .value, with: { snapshot in
                 if ( snapshot.value is NSNull ) {
                    
                     print("– – – Data was not found – – –")
                    
                    self.viewDetailButton.isEnabled = false
                    self.viewDetailButton.alpha = 0.8
                    self.noPlansView.isHidden = false
                    
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
               
                        
                self.upcomingMeetup.append(MeetUp(shortTimestamp: shortTimestamp, longTimestamp: longTimestamp , buddiesArray: buddies as! [String], address: address, place: place, rating: rating, longitude: longitude, latitude: latitude, phoneNumber: phoneNumber,types: types, createdAt: createdAt!, buddyCount: buddyCount!, emoji: emoji!, buddiesIDArray: buddiesID! as! [String], organiserName: organiserName!, meetupID: meetupID!, status: self.statusList,meetupTitle: meetupTitle!, organisedBy: organisedBy!))
                        
                self.upcomingMeetup = self.upcomingMeetup.filter { $0.shortTimestamp >= self.todayTimeStamp }
                self.upcomingMeetup.sort { $0.longTimestamp < $1.longTimestamp }
                        
            }
                    
        DispatchQueue.main.async {
                        
            if self.upcomingMeetup.isEmpty {
                            
                self.viewDetailButton.isEnabled = false
                self.viewDetailButton.alpha = 0.8
                self.noPlansView.isHidden = false
                        
            } else {
                           
                [self.timeIconButton, self.titleLabelUpcoming, self.locationIconButton, self.arrowView].forEach {
                    $0?.isHidden = false
            }
                            
                self.viewDetailButton.isEnabled = true
                self.viewDetailButton.alpha = 1
                            
                let date = Date(timeIntervalSince1970: self.upcomingMeetup[0].longTimestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a EEE d MMM"
                
                self.locationLabelUpcoming?.text = self.upcomingMeetup[0].place
                self.meetupTitle = self.upcomingMeetup[0].meetupTitle
                self.meetupTitleLabel?.text = self.upcomingMeetup[0].meetupTitle
                self.buddyCountUpcoming = self.upcomingMeetup[0].buddyCount
                self.buddiesList = self.upcomingMeetup[0].buddiesArray
                self.dateLabelUpcoming?.text = dateFormatter.string(from: date)
                self.emojiLabelUpcoming?.setTitle(self.upcomingMeetup[0].emoji, for: .normal)
                self.organiser = self.upcomingMeetup[0].organiserName
                            
            }
        }

                self.dayOneMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().0 }
                self.dayTwoMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().1 }
                self.dayThreeMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().2 }
                self.dayFourMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().3 }
                self.dayFiveMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().4 }
                self.daySixMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().5 }
                self.daySevenMeetup = self.upcomingMeetup.filter { $0.shortTimestamp == SevenDays().getSevenDays().6 }
            
            }
                
        let dayOneString = Date(timeIntervalSince1970: SevenDays().getSevenDays().0)
        let dayTwoString = Date(timeIntervalSince1970: SevenDays().getSevenDays().1)
        let dayThreeString = Date(timeIntervalSince1970: SevenDays().getSevenDays().2)
        let dayFourString = Date(timeIntervalSince1970: SevenDays().getSevenDays().3)
        let dayFiveString = Date(timeIntervalSince1970: SevenDays().getSevenDays().4)
        let daySixString = Date(timeIntervalSince1970: SevenDays().getSevenDays().5)
        let daySevenString = Date(timeIntervalSince1970: SevenDays().getSevenDays().6)
                    
        let planCounts = [self.dayOneMeetup.count,self.dayTwoMeetup.count,self.dayThreeMeetup.count,self.dayFourMeetup.count,self.dayFiveMeetup.count,self.daySixMeetup.count,self.daySevenMeetup.count]
                
        let days = [self.dayOneMeetup, self.dayTwoMeetup,self.dayThreeMeetup,self.dayFourMeetup,self.dayFiveMeetup,self.daySixMeetup,self.daySevenMeetup]
                
        let buttons = [self.dayOneButton, self.dayTwoButton,self.dayThreeButton,self.dayFourButton,self.dayFiveButton,self.daySixButton,self.daySevenButton]
                
        self.dayStrings = [dayOneString, dayTwoString, dayThreeString, dayFourString, dayFiveString, daySixString, daySevenString]
                
        let dayViews = [self.dayOneView, self.dayTwoView,self.dayThreeView,self.dayFourView,self.dayFiveView,self.daySixView,self.daySevenView]
                
        for (index, button) in buttons.enumerated() {
                                   
            button!.tag = index
                       
            if days[index].isEmpty {
                           
            button!.addTarget(self, action: #selector(self.seeEvent(_:)), for: .touchUpInside)
            button!.setAttributedTitle(noPlans().noPlansString(formatter1: formatter1, formatter2: formatter2, dayString: self.dayStrings[index], planString: "No Plans",color: .darkGray), for: .normal)
            dayViews[index]!.layer.addSublayer(dashRect().dashRectFunction(roundedView: dayViews[index]!))
                     
                                    
        }
                           
        else {
                var countString = ""
            
                if planCounts[index] == 1 {
                    
                    countString = "Plan"
                } else {
                    
                    countString = "Plans"
                }
            
                button!.addTarget(self, action: #selector(self.seeEvent(_:)), for: .touchUpInside)
                button!.setAttributedTitle(noPlans().noPlansString(formatter1: formatter1, formatter2: formatter2, dayString: self.dayStrings[index], planString: String("\(planCounts[index]) \(countString)"), color: .white), for: .normal)
                dayViews[index]!.backgroundColor = UIColor.init(named: "appGreen")!
                   
            }
        }
                
      })
    }
    
    @objc func pushNotif() {

        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
        pushManager.registerForPushNotifications()
        
    }

    @objc func loggedOut() {

        self.showVC(vcString: "loginVC", storyboard: "Home", style: .fullScreen)
        
    }

    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getUpcomingInvites.upcomingInvites.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let date = Date(timeIntervalSince1970: getUpcomingInvites.upcomingInvites[indexPath.row].longTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a EEE d-MMM"
        
        let cell : HomeTableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! HomeTableCell

        cell.title.text = getUpcomingInvites.upcomingInvites[indexPath.row].meetupTitle
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.emojiButton.setTitle(getUpcomingInvites.upcomingInvites[indexPath.row].emoji, for: .normal)
        cell.location.text = getUpcomingInvites.upcomingInvites[indexPath.row].place

        return cell;

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
              
        if tableView.cellForRow(at: indexPath as IndexPath) != nil {
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "meetUpVC") as! MeetUpVC
            vc.modalPresentationStyle = .pageSheet
            vc.buddiesArray = getUpcomingInvites.upcomingInvites[indexPath.row].buddiesArray
            vc.statusArray = getUpcomingInvites.upcomingInvites[indexPath.row].status
            vc.timeStamp = getUpcomingInvites.upcomingInvites[indexPath.row].longTimestamp
            vc.locationTitle = getUpcomingInvites.upcomingInvites[indexPath.row].place
            vc.meetupTitle = getUpcomingInvites.upcomingInvites[indexPath.row].meetupTitle
            vc.emojiTitle = getUpcomingInvites.upcomingInvites[indexPath.row].emoji
            vc.buddyCount = getUpcomingInvites.upcomingInvites[indexPath.row].buddiesArray.count
            vc.meetupID = getUpcomingInvites.upcomingInvites[indexPath.row].meetupID
            vc.organiserString = getUpcomingInvites.upcomingInvites[indexPath.row].organiserName
            vc.latitude = getUpcomingInvites.upcomingInvites[indexPath.row].latitude
            vc.longitude = getUpcomingInvites.upcomingInvites[indexPath.row].longitude
            vc.address = getUpcomingInvites.upcomingInvites[indexPath.row].address
            vc.rating = getUpcomingInvites.upcomingInvites[indexPath.row].rating
            vc.phoneNumber = getUpcomingInvites.upcomingInvites[indexPath.row].phoneNumber
            vc.isMyMeetup = false
            self.present(vc, animated: true, completion: nil)
                
        }
    }
    
     @objc func seeEvent(_ sender: UIButton) {
        
        let index = sender.tag
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "dayVC") as! DayViewController
                vc.todayTimeStamp = self.dayStrings[index].timeIntervalSince1970
                self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
}
    

    


