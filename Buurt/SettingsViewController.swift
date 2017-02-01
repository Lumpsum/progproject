//
//  SettingsViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 14-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var lockValue = true
    var imagePicker = UIImagePickerController()
    var picturePath = String()
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var postcodeField: UITextField!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var lockIcon: UIBarButtonItem!
    @IBOutlet var profilePicture: UIImageView!

    @IBAction func ProfilePictureDidTap(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func UpdateButtonDidTouch(_ sender: Any) {
        let userRef = FIRDatabase.database().reference(withPath: "users").child(currentInfo.user["uid"]!)
        userRef.updateChildValues(["firstname": firstNameField.text!])
        userRef.updateChildValues(["lastname": lastNameField.text!])
        userRef.updateChildValues(["email": emailField.text!])
        userRef.updateChildValues(["postcode": postcodeField.text!])
        userRef.updateChildValues(["picture": picturePath])
    }
    
    @IBAction func LogOutButtonDidTouch(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        currentInfo.mentions = Array<MentionItem>()
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        imagePicker.delegate = self
        
        self.firstNameField.text = currentInfo.user["firstname"]!
        self.lastNameField.text = currentInfo.user["lastname"]!
        self.emailField.text = currentInfo.user["email"]!
        self.postcodeField.text = currentInfo.user["postcode"]!
        setProfilePictures(pictureUrl: currentInfo.uidPictureDict[currentInfo.user["uid"]!], pictureHolder: self.profilePicture, userid: currentInfo.user["uid"]!)

        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.image = image
            profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
            profilePicture.clipsToBounds = true
            
            saveImage(image: profilePicture.image!)
        }
        else {
            print("Image picking went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Saves given UIImage for currentuser as profilepicture.
    private func saveImage(image: UIImage) {
        var data = NSData()
        data = UIImageJPEGRepresentation(image, 0.8)! as NSData
        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("profilePicture")"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
        FIRStorage.storage().reference().child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print("IMAGE UPLOAD ERROR", error.localizedDescription)
                return
            } else {
                self.picturePath = metaData!.downloadURL()!.absoluteString
            }
        }

    }
    
    
}
