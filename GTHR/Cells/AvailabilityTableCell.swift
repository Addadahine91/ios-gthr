//
//  AvailabilityTableCell.swift
//  GTHR
//
//  Created by Sam Addadahine on 01/12/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import UIKit

class AvailabilityTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var days = ["M", "T", "W", "Th", "F", "S", "Su"]
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var inviteName: UILabel!
    @IBOutlet var nudgeView: UIView!
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nudgeView.layer.cornerRadius = 8
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier:"cell")
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        
         return 1
         
     }

     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             
            return days.count
         
     }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionCell
         
        cell.dayLabel.text = days[indexPath.row]
         
        return cell
        
    }

   
}
