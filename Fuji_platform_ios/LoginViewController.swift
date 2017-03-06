//
//  LoginViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LoginViewController: BasicViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    
    @IBAction func login(_ sender: Any) {
        Logger.log(string: "Clicked login")
        
        if !Utils.isOnline(){
            Alert.show(viewController: self, message: Constant.YOU_ARE_OFFLINE)
            return
        }
        
        login()
    }
    
    @IBAction func signup(_ sender: Any) {
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let signupViewController = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_SIGNUP_ID) as! SignupViewController
        
        self.navigationController?.pushViewController(signupViewController, animated: true)

    }
    
    override func viewDidLoad() {
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
        
        self.title = Constant.LOGIN_TITLE
        
    }
    
    private func login(){
        let username = textfieldUsername.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let password = textfieldPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let (isValid, user) = validate()
        
        if !isValid {
            Alert.show(viewController: self, message: Constant.LOGIN_ERROR_MESSAGE)
        } else {
            Indicator.start(context: self.view)

            user?.setPassword(password: (user?.getPassword().sha256())!)
            
            func callback(isSuccess: Bool, message: String) {
                Indicator.stop()
                
                if isSuccess {
                    Toast.show(context: self.view, text: Constant.LOGIN_SUCCESS)
                    
                    goToHomeViewController()
                    
                } else {
                    Toast.show(context: self.view, text: Constant.LOGIN_FAIL)
                }
            }
            
            User.login(user: user!, callback: callback)
        }
    }
    
    private func validate() -> (Bool, User?) {
        let username = textfieldUsername.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let password = textfieldPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if (username?.isEmpty)! || (password?.isEmpty)!{
          return (false, nil)
        } else {
            return (true, User.init(username: username!, password: password!))
        }
    }
    
    private func goToHomeViewController(){
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_HOME_ID) as! HomeViewController
        let navController = UINavigationController(rootViewController: homeViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
}
