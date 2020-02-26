//
//  MyProfileViewController.swift
//  Pint
//
//  Created by Sam Addadahine on 19/11/2019.
//  Copyright © 2019 Sam Addadahine. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SDWebImage

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Class Properties
    
    var imagePicker = UIImagePickerController()
    
    // MARK: - UIViewController Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let pathReference = Storage.storage().reference(withPath: "profile_image_urls/\(Constants.userUid).png")
//        let gsReference = Storage.storage().reference(forURL: "\(Constants.storageUrl)/profile_image_urls/\(Constants.userUid).png")
        
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
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if error != nil {
//            // Uh-oh, an error occurred!
//                print("No image")
//                self.imageView.image = UIImage(named: "profilePlaceholder.png")
//          } else {
//            // Data for "images/island.jpg" is returned
//            let image = UIImage(data: data!)
//                self.imageView.image = image
//          }
//        }
        
        imagePicker.delegate = self
        self.nameLabel.text! = Constants.fullName
        
        self.imageView.roundedImage()
}
    
    @IBAction func pickImage() {
        
       let image = UIImagePickerController()
       image.delegate = self

       image.sourceType = UIImagePickerController.SourceType.photoLibrary

       image.allowsEditing = false

       self.present(image, animated: true)
       {
           //After it is complete
       }

    }

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imageView.image = image
            
           guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
                    let profileImgReference = Storage.storage().reference().child("profile_image_urls").child("\(uid).png")
                    let uploadTask = profileImgReference.putData(imageData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            
                        }
                    }
                    uploadTask.observe(.progress, handler: { (snapshot) in
                        print(snapshot.progress?.fractionCompleted ?? "")
                        // Here you can get the progress of the upload process.
                    })
            }
        
        else{
            //
        }
    
        self.dismiss(animated: true, completion: nil)

    }
    
}
