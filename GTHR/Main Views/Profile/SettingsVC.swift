//
//  SettingsVC.swift
//  GTHR
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FittedSheets

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emailSwitch:  UISwitch!
    @IBOutlet var pushSwitch:  UISwitch!
    @IBOutlet var updatesSwitch:  UISwitch!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Variables
    
    var tableItems = ["My Plans","My Friends","Privacy Policy","Terms of Service","About Us"]
    //var tableImages = [UIImage(named:"About.png"),UIImage(named:"licenses.png"),UIImage(named:"About.png"),UIImage(named:"About.png"),UIImage(named:"block.png")]
    
    var ref = Database.database().reference()
    
    //User Info
    var firstName = ""
    var bio = ""
    var placeholderImage: UIImage!
    var profileImage: UIImage?
    
    // MARK: - Constants
    
    // MARK: - View Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfile()
        
        emailSwitch.isOn = true
        pushSwitch.isOn = false
        updatesSwitch.isOn = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsTableCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        if placeholderImage != nil {
                   
            imageView.image = placeholderImage!
                   
        }
        
        imageView.roundedImage()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        nameLabel.text = firstName
        
    }
    
    func getProfile() {
        
        self.nameLabel.text = Constants.firstName
        
        let storageRef = Storage.storage().reference().child("profile_image_urls/\(Constants.userUid).png")
               
              storageRef.downloadURL { url, error in
                 guard let url = url else { return }
                 self.imageView.sd_setImage(with: url, placeholderImage: nil, completed: { (image, error, cacheType, storageRef) in
                   if image != nil && error != nil {
                     UIView.animate(withDuration: 0.3) {
                       self.imageView.alpha = 1
                     }
                   }
                 })
               }
    }

    // MARK: - IBActions

    @IBAction func closeAction() {
        
        self.dismiss(animated: true, completion: nil)
            
    }
    
    @IBAction func logout() {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
                                   
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in

                try! Auth.auth().signOut()
                                      
                self.dismiss(animated: true, completion: nil)
                                          
                NotificationCenter.default.post(name: .loggedOut, object: nil)

            }))
                                   
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
    
    }
    
    // MARK: - objc Functions
    
    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        return tableItems.count
    }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell : SettingsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
    
        cell.userName.text = tableItems[indexPath.row]
        //cell.userImage.image = tableImages[indexPath.row]
        cell.selectionStyle = .none
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0:
            // My Plans
            print("My Plans")
            
            self.showVC(vcString: "mymeetupsVC", storyboard: "Main", style: .fullScreen)
            
        case 1:
            // My Friends
            print("My Friends")
            
            self.showVC(vcString: "myFriendVC", storyboard: "Main", style: .fullScreen)
            
        case 2:
            // Privacy Policy
            print("Privacy Policy")
            
        case 3:
            // Terms of  Service
            print("Terms")
            
        case 4:
            // About Us
            print("About")
            
        default:
            // Default
            print("default")
        }
        
      
    }
    
   
}
