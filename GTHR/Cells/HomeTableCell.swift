//
//  HomeTableCell.swift
//  GTHR
//
//  Created by Sam Addadahine on 01/12/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet var title : UILabel!
    @IBOutlet var innerView : UIView!
    @IBOutlet var location: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var emojiButton: UIButton!

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerView.layer.cornerRadius = 10
        
        innerView.dropShadow()
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
    }

   
}
