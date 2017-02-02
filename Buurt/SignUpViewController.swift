//
//  SignUpViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 12-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordCheckField: UITextField!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var postcodeField: UITextField!
    
    @IBAction func SignUpButtonDidTouch(_ sender: Any) {
        if checkInputFields() && checkPasswords() {
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    self.saveUserData(userid: (user?.uid)!)
                    currentInfo.user["uid"] = (user?.uid)!
                    let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Start")
                    UIApplication.shared.keyWindow?.rootViewController = loginViewController
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Checks if all fields in SingUpViewController do have some input, returns bool.
    private func checkInputFields() -> Bool {
        if emailField.text != "" && passwordField.text != "" && passwordCheckField.text != "" && firstNameField.text != "" && lastNameField.text != "" && postcodeField.text != "" {
                return true
        }
        showSignUpAlert(showMessage: "Vul alle velden in.")
        return false
    }
    
    /// Checks if the password and ceckpassword are the same and the password is longer than 5 characters, returns bool.
    private func checkPasswords() -> Bool {
        if (passwordField.text?.characters.count)! >= 6 {
            if passwordField.text == passwordCheckField.text  {
                return true
            }
            showSignUpAlert(showMessage: "Controle wachtwoord is niet correct ingevuld.")
            return false
        }
        showSignUpAlert(showMessage: "Wachtwoord moet minimaal uit 6 karakters bestaan.")
        return false
    }
    
    private func showSignUpAlert(showMessage: String) {
        let alert = UIAlertController(title: "Registreren mislukt", message: showMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Saves all aditional userinformation to database at registration.
    private func saveUserData(userid: String) {
        let userItem = User(uid: userid,
                            email: self.emailField.text!,
                            firstname: self.firstNameField.text!,
                            lastname: self.lastNameField.text!,
                            postcode: self.postcodeField.text!,
                            followlist: [""])
        let userItemRef = FIRDatabase.database().reference(withPath: "users").child((FIRAuth.auth()?.currentUser?.uid)!)
        userItemRef.setValue(userItem.toAnyObject())
    }

}
