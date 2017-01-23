//
//  ViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 09-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        FIRAuth.auth()!.signIn(withEmail: emailField.text!, password: passwordField.text!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                
                currentInfo.user["uid"] = (user?.uid)!
                    
                self.performSegue(withIdentifier: "LoginToFeed", sender: nil)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

