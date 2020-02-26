//
//  NotificationCell.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet var notificationString: UILabel!
    @IBOutlet var notificationDate: UILabel!
    @IBOutlet var iconButton: UIButton!
    
    @IBOutlet var innerContentView: UIView!
    
    override func prepareForReuse() {
      super.prepareForReuse()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        innerContentView.layer.cornerRadius = 10
        innerContentView.dropShadow()

    }
    
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
}

