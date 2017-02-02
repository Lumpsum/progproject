//
//  TextFieldExtension.swift
//  Buurt
//
//  Extension created by Nhgrif
//  http://stackoverflow.com/questions/27028617/using-next-as-a-return-key
//
//  Created by Martijn de Jong on 02-02-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
