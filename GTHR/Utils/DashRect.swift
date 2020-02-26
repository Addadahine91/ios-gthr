//
//  DashRect.swift
//  GTHR
//
//  Created by Sam Addadahine on 03/12/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import UIKit

class dashRect {
    
    func dashRectFunction(roundedView: UIView) -> CAShapeLayer {
        
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = UIColor.init(named: "appGreen")?.cgColor
        viewBorder.lineDashPattern = [2, 2]
        viewBorder.frame = roundedView.bounds
        viewBorder.fillColor = nil
        viewBorder.cornerRadius = 15
        viewBorder.path = UIBezierPath(roundedRect: roundedView.bounds, cornerRadius: 15).cgPath
        
        return viewBorder
    }
}
    
class noPlans {
        
    func noPlansString(formatter1: DateFormatter, formatter2: DateFormatter, dayString: Date, planString: String, color: UIColor) -> NSMutableAttributedString {
           
           let attString = NSMutableAttributedString(string: formatter1.string(from: dayString) + "\n",
               attributes: [NSAttributedString.Key.font: UIFont(name: "Futura", size: 10)!,
               NSAttributedString.Key.foregroundColor: color])
                                                            
               attString.append(NSMutableAttributedString(string: formatter2.string(from: dayString) + "\n\n",
               attributes: [NSAttributedString.Key.font:  UIFont(name: "Futura", size: 10)!,
               NSAttributedString.Key.foregroundColor: color]))
                                                            
               attString.append(NSMutableAttributedString(string: planString,
               attributes: [NSAttributedString.Key.font:  UIFont(name: "Futura", size: 14)!,
               NSAttributedString.Key.foregroundColor: color]))
                       
           return attString
       }
        
}
    
