//
//  UpcomingInvites.swift
//  Pint
//
//  Created by Sam Addadahine on 22/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol UpcomingInvitesDelegate {
    func didFinishGetUpcomingInvites(finished: Bool)
}

class UpcomingInvites {
    
     var statusList = [String]()
     var upcomingInvites = [MeetUp]()
     var delegate: UpcomingInvitesDelegate?
     var acceptDict = [String:String]()
    
    func getUpcomingInvites() {
        
        let timeInterval = floor(Date().timeIntervalSinceReferenceDate / 86400) * 86400
        let today = Date(timeIntervalSinceReferenceDate: timeInterval)
        let todayTimeStamp = today.timeIntervalSince1970

        Constants.ref.child("meetups").queryOrdered(byChild: "buddiesID2/\(Constants.userUid)").queryEqual(toValue: true).observeSingleEvent(of: .value, with: { snapshot in
                    
            if ( snapshot.value is NSNull ) {
                print("- - - No Data was found – – –")
                       
            } else {
                       
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                        let dict = snap.value as! [String: Any]
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
                        
                        self.upcomingInvites.append(MeetUp(
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
                           
                        self.upcomingInvites = self.upcomingInvites.filter { $0.shortTimestamp >= todayTimeStamp }
                        self.upcomingInvites.sort { $0.shortTimestamp < $1.shortTimestamp }
                        
                       }
                       
                        self.delegate?.didFinishGetUpcomingInvites(finished: true)
                   
                   }
                   
               }
           )}
    
}
