//
//  SettingsViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 14-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBAction func updateUserData(_ sender: Any) {
        
        let userRef = FIRDatabase.database().reference(withPath: "users").child(currentInfo.user["uid"]!)
        userRef.updateChildValues(["firstname": firstNameField.text!])
        userRef.updateChildValues(["lastname": lastNameField.text!])
        userRef.updateChildValues(["email": emailField.text!])
        
    }
    @IBAction func logOutAction(_ sender: Any) {
    
        try! FIRAuth.auth()!.signOut()
        currentInfo.mentions = Array<MentionItem>()
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameField.text = currentInfo.user["firstname"]!
        self.lastNameField.text = currentInfo.user["lastname"]!
        self.emailField.text = currentInfo.user["email"]!
            
        // SIDE BAR MENU SETUP
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
