//
//  BasicViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit


class BasicViewController: UIViewController, UITextFieldDelegate {
    
    public func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func setBackButtonText(text: String){
        let backButton = UIBarButtonItem(title: text, style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }

}
