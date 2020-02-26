//
//  SevenDays.swift
//  GTHR
//
//  Created by Sam Addadahine on 07/12/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation

class SevenDays {
    
    let formatter1 = DateFormatter()
    let formatter2 = DateFormatter()
    var timeInterval: Double = 0.0
    
    let today = Date()
    
    func getSevenDays() -> (Double,Double,Double,Double,Double,Double,Double) {
        
        formatter1.dateFormat = "EEEE"
        formatter2.dateFormat = "dd MMM"
        timeInterval = floor(Date().timeIntervalSinceReferenceDate / 86400) * 86400
        
        let today = Date(timeIntervalSinceReferenceDate: timeInterval)
        let todayPlusOne = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let todayPlusTwo = Calendar.current.date(byAdding: .day, value: 2, to: today)
        let todayPlusThree = Calendar.current.date(byAdding: .day, value: 3, to: today)
        let todayPlusFour = Calendar.current.date(byAdding: .day, value: 4, to: today)
        let todayPlusFive = Calendar.current.date(byAdding: .day, value: 5, to: today)
        let todayPlusSix = Calendar.current.date(byAdding: .day, value: 6, to: today)
        let todayPlusSeven = Calendar.current.date(byAdding: .day, value: 7, to: today)

        let todayPlusOneStamp = todayPlusOne!.timeIntervalSince1970
        let todayPlusTwoStamp = todayPlusTwo!.timeIntervalSince1970
        let todayPlusThreeStamp = todayPlusThree!.timeIntervalSince1970
        let todayPlusFourStamp = todayPlusFour!.timeIntervalSince1970
        let todayPlusFiveStamp = todayPlusFive!.timeIntervalSince1970
        let todayPlusSixStamp = todayPlusSix!.timeIntervalSince1970
        let todayPlusSevenStamp = todayPlusSeven!.timeIntervalSince1970
        
        return (Double(todayPlusOneStamp), Double(todayPlusTwoStamp), Double(todayPlusThreeStamp), Double(todayPlusFourStamp), Double(todayPlusFiveStamp), Double(todayPlusSixStamp), Double(todayPlusSevenStamp))
    }

}
