//
//  SignupViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit
import Regex

class SignupViewController: BasicViewController {
    
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldPasswordConfirm: UITextField!
    
    @IBOutlet weak var textfieldEmail: UITextField!
    
    @IBAction func buttonSignup(_ sender: Any) {
        let (status, message, user) = validateForm()
        
        func callback(isSuccess: Bool, message: String) {
            Indicator.stop()
            
            if isSuccess {
                Toast.show(context: self.view, text: message)
                
                gotoLoginViewController()
                
            } else {
                
                Toast.show(context: self.view, text: message)
            }
        }
        
        if status {
            // SUBMIT
            
            if !Utils.isOnline() {
                Alert.show(viewController: self, message: Constant.YOU_ARE_OFFLINE)
                return
            }
            
            Indicator.start(context: self.view)
            User.signup(user: user!, callback: callback)
        } else {
            // in-valid
            Logger.log(string: message)
            Alert.show(viewController: self, message: message)
        }
    }
    
    override func viewDidLoad() {
        self.title = Constant.SIGNUP_TITLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func validateForm() -> (Bool, String, User?) {
        let username: String = textfieldUsername.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        let password: String = textfieldPassword.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordConfirm: String = textfieldPasswordConfirm.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        let email: String = textfieldEmail.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let regexUsername: Regex = Regex("^([0-9a-zA-Z]|\\.|_){8,20}$")
        let regexEmail: Regex = Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        
        if (email.isEmpty || passwordConfirm.isEmpty || password.isEmpty || username.isEmpty) {
            return (false, Constant.MISSING_INFOMATION, nil)
            
        } else if !regexUsername.matches(username) {
            return (false, Constant.IN_VALIDATE_USERNAME, nil)
            
        } else if password != passwordConfirm {
            return (false, Constant.PASSWORD_NOT_MATCHES, nil)
            
        } else if !regexEmail.matches(email) {
//            return (false, Constant.IN_VALIDATE_EMAIL)
        }
        
        return (true, "OK", User.init(username: username, password: password.sha256(), email: email))
    }
    
    private func gotoLoginViewController(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_LOGIN_ID) as! LoginViewController
////        let navController = UINavigationController(rootViewController: controller)
////        self.present(navController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(controller, animated: true)
        
        navigationController?.popViewController(animated: true)
    }
}
