//
//  ForgotPasswordViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/7/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordViewController: BasicViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var textfieldEmail: UITextField!
    
    
    @IBOutlet weak var buttonGetPassword: UIButton!
    
    @IBAction func buttonGetPassword(_ sender: Any) {
        Logger.log(string: "Clicked get password")
        
        getPassword()
    }
    
    override func viewDidLoad() {
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
    }
    
    private func getPassword(){
        
        if !validate() {
            return
        }
        
        let email = textfieldEmail.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        func callback (isSussess: Bool, message: String) {
            Indicator.stop()
            
            if isSussess {
                Alert.show(viewController: self, message: message, callback: {
                    self.gotoLoginViewController()
                })
            } else {
                Toast.show(context: self.view, text: message)
            }
        }
        
        Indicator.start(context: self.view)
        
        User.forgotPassword(email: email!, callback: callback)
    }
    
    private func validate() -> Bool{
        let email = textfieldEmail.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if !Utils.isOnline() {
            Toast.show(context: self.view, text: Constant.YOU_ARE_OFFLINE)
            
            return false
        } else if (email?.isEmpty)! {
            Toast.show(context: self.view, text: Constant.MISSING_INFOMATION)
            
            return false
        }
        
        return true
    }
    
    private func gotoLoginViewController(){
        navigationController?.popViewController(animated: true)
    }
}
