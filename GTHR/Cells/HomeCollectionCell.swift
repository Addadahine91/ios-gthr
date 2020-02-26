//
//  HomeCollectionCell.swift
//  GTHR
//
//  Created by Sam Addadahine on 30/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.layer.cornerRadius = 5
        innerView.layer.addSublayer(dashRect().dashRectFunction(roundedView: innerView!))
        
    }
}
