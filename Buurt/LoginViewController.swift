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
        if emailField.text != "" && passwordField.text != "" {
            FIRAuth.auth()!.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Inloggen mislukt", message: "Mailadres of wachtwoord is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Inloggen mislukt", message: "Vul uw mailadres en/of wachtwoord in.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CHECK IF USER ALREADY LOGGED IN
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                // SET CURRENT UID LOCAL
                currentInfo.user["uid"] = (user?.uid)!
                
                // GO TO FEED
                self.performSegue(withIdentifier: "LoginToFeed", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

