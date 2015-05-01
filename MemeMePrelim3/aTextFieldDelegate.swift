//
//  ATextFieldDelegate.swift
//  MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 5/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import Foundation
import UIKit

class aTextFieldDelegate: NSObject, UITextFieldDelegate
    {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
    }
}

