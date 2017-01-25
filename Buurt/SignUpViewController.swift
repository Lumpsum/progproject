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
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordCheckField: UITextField!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var postcodeField: UITextField!
    
    @IBAction func SignUp(_ sender: Any) {
        if checkInputFields() && checkPasswords() {
        // CREATE USER
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                
                    // SAVE ADDITIONAL USERINFORMATION IN DATABASE
                    let userItem = User(uid: (user?.uid)!,
                                        email: self.emailField.text!,
                                        firstname: self.firstNameField.text!,
                                        lastname: self.lastNameField.text!,
                                        postcode: self.postcodeField.text!,
                                        followlist: ["test"])
                    let userItemRef = self.ref.child((FIRAuth.auth()?.currentUser?.uid)!)
                    userItemRef.setValue(userItem.toAnyObject())
                
                    // SET CURRENT UID LOCAL
                    currentInfo.user["uid"] = (user?.uid)!
                
                    // SEND TO MAINVIEWCONTROLLER
                    let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Start")
                    UIApplication.shared.keyWindow?.rootViewController = loginViewController
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkInputFields() -> Bool {
        if emailField.text != "" && passwordField.text != "" && passwordCheckField.text != "" && firstNameField.text != "" && lastNameField.text != "" && postcodeField.text != "" {
                return true
        }
        showAlert(showMessage: "Vul alle velden in.")
        return false
    }
    
    func checkPasswords() -> Bool {
        if (passwordField.text?.characters.count)! >= 6 {
            if passwordField.text == passwordCheckField.text  {
                return true
            }
            showAlert(showMessage: "Controle wachtwoord is niet correct ingevuld.")
            return false
        }
        showAlert(showMessage: "Wachtwoord moet minimaal uit 6 karakters bestaan.")
        return false
    }
    
    func showAlert(showMessage: String) {
        let alert = UIAlertController(title: "Registreren mislukt", message: showMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
