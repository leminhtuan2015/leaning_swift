//
//  FujiSDK.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/13/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class FujiSDK {
    
    class func initialize () {
        User.loadSession()
    }
    
    class func login(viewController: UIViewController){
        
        if User.isLoggedIn() {
            Toast.show(context: viewController.view, text: Constant.LOGGED_IN)
            
            return
        }
        
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_LOGIN_ID) as! LoginViewController
        
        if viewController.navigationController != nil {
            viewController.navigationController?.pushViewController(loginViewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: loginViewController)
            viewController.present(navController, animated: true, completion: nil)
        }
        
    }
    
    class func logout(viewController: UIViewController, callback1: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        
        if !User.isLoggedIn() {
            Toast.show(context: viewController.view, text: Constant.NOT_LOGGED_IN)
            
            return
        }
        
        func callback(isOk: Bool) {
            if isOk {
                Logger.log(string: "Ok Logout")
                
                func callback (isSuccess: Bool, message: String) {
                    if(isSuccess){
                        Toast.show(context: viewController.view, text: Constant.LOGOUT_SUCCESS)
                        
                        callback1( true, Constant.SUCCESS)
                    } else {
                        Toast.show(context: viewController.view, text: Constant.LOGOUT_FAIL)
                        
                        callback1(false, Constant.SOMETHING_WENT_WRONG)
                    }
                }
                
                User.logout(callback: callback)
            }
            
        }
        
        Alert.confirm(viewController: viewController, message: Constant.LOGOUT_CONFIRM, callback: callback)
        
    }
    
    class func userInfo(viewController: UIViewController){
        if(!User.isLoggedIn()){
            Toast.show(context: viewController.view, text: Constant.NOT_LOGGED_IN)
            return
        }
        
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let userInfoViewController = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_USER_INFO_ID) as! UserInfoViewController
        
        if viewController.navigationController != nil {
            viewController.navigationController?.pushViewController(userInfoViewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: userInfoViewController)
            viewController.present(navController, animated: true, completion: nil)
        }
    }
    
    class func tranferCoin(viewController: UIViewController, packageCode: String){
        if(!User.isLoggedIn()){
            Toast.show(context: viewController.view, text: Constant.NOT_LOGGED_IN)
            return
        }
        
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let paymentViewController = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_PAYMENT_ID) as! PaymentViewController
        paymentViewController.setPackageCode(packageCode: packageCode)
        
        if viewController.navigationController != nil {
            viewController.navigationController?.pushViewController(paymentViewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: paymentViewController)
            viewController.present(navController, animated: true, completion: nil)
        }
    }
    
}











