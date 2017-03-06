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
        login()
    }
    
    @IBAction func signup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.present(vc, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
        
        self.title = Constant.LOGIN_TITLE
        
    }
    
    private func login(){
        let username = textfieldUsername.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let password = textfieldPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if (username?.isEmpty)! || (password?.isEmpty)!{
            let alert = UIAlertController(title: Constant.NOTICE,
                                          message: Constant.LOGIN_ERROR_MESSAGE,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: Constant.OK,
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Indicator.start(context: self.view)

            let username = textfieldUsername.text!
            let password = Utils.sha256(string: textfieldPassword.text!)
            
            func callback(isSuccess: Bool, message: String) {
                Indicator.stop()
                
                if isSuccess {
                    Toast.show(context: self.view, text: Constant.LOGIN_SUCCESS)
                    
                    goToHomeViewController()
                    
                } else {
                    Toast.show(context: self.view, text: Constant.LOGIN_FAIL)
                }
            }
            
            User.login(user: User(username: username, password: password), callback: callback)
        }
    }
    
    private func goToHomeViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController(rootViewController: homeViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
}
