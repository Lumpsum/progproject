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
    
    @IBAction func LoginButtonDidTouch(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            FIRAuth.auth()!.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error != nil {
                    self.showLoginAlert(showMessage: "Mailadres of wachtwoord is incorrect.")
                }
            }
        }
        else {
            self.showLoginAlert(showMessage: "Vul uw mailadres en/of wachtwoord in.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                currentInfo.user["uid"] = (user?.uid)!
                self.performSegue(withIdentifier: "LoginToFeed", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Shows alert with given message and specific title for Login.
    private func showLoginAlert(showMessage: String) {
        let alert = UIAlertController(title: "Inloggen mislukt", message: showMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

