//
//  SettingsTableCell.swift
//  GTHR
//
//  Created by Sam Addadahine on 27/12/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableCell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    override func prepareForReuse() {
         super.prepareForReuse()
       }
      
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
       
       
       override func awakeFromNib() {
           super.awakeFromNib()

           
       }
}
