//
//  ViewControllerExtension.swift
//  Buurt
//
//  Extension created by goktugyil
//  https://github.com/goktugyil/EZSwiftExtensions
//
//  Created by Martijn de Jong on 31-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
