//
//  UpdatePasswordViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/8/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class UpdatePasswordViewController: BasicViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    @IBOutlet weak var textViewCurrentPassword: UITextField!
    
    @IBOutlet weak var textViewNewPassword: UITextField!
    
    @IBOutlet weak var textViewNewPasswordConfirm: UITextField!
    
    
    @IBAction func buttonUpdatePassword(_ sender: Any) {
        changePassword()
    }
    
    override func viewDidLoad() {
        self.title = Constant.USER_UPDATE_PASSWORD_TITLE
        
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
    }
    
    private func changePassword(){
        let (isValid, message) = validate()
        
        if !isValid {
            Toast.show(context: self.view, text: message)
            
            return
        } else {
            Indicator.start(context: self.view)
            
            func callback(isSuccess: Bool, message: String, user: User?){
                Indicator.stop()
                Toast.show(context: self.view, text: message)
                
                if isSuccess {
                    User.updateSession(password: (user?.getPassword())!)
                    
                    Alert.show(viewController: self, message: message, callback: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                } else {
                    Toast.show(context: self.view, text: message)
                }
            }
            
            let newPasswordConfirm = textViewNewPasswordConfirm.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            let newPassword = (newPasswordConfirm?.sha256())!
            
            User.updatePassword(newPassword: newPassword, user: User.getCurrentUser(), callback: callback)
        }
        
    }
    
    private func validate() -> (Bool, String) {
        let currentPassword = textViewCurrentPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let newPassword = textViewNewPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let newPasswordConfirm = textViewNewPasswordConfirm.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        Logger.log(string: (currentPassword?.sha256())!)
        Logger.log(string: User.getCurrentUser().getPassword())
        
        if (currentPassword?.isEmpty)! || (newPassword?.isEmpty)! || (newPasswordConfirm?.isEmpty)! {
            return (false, Constant.MISSING_INFOMATION)
            
        } else if (currentPassword?.sha256())! != User.getCurrentUser().getPassword() {
            return (false, Constant.CURRENT_PASSWORD_WRONG)
            
        } else if newPassword != newPasswordConfirm {
            
            return (false, Constant.NEW_PASSWORD_AND_NEW_PASWORD_CONFIRM_NOT_MATCHES)
        } else if (newPasswordConfirm?.sha256())! == User.getCurrentUser().getPassword(){
            
            return (false, Constant.NEW_PASSWORD_AND_OLD_PASSOWRD_MATCHES)
        }
        
        return (true, "")
    }
}
