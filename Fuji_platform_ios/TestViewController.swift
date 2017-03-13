//
//  TestViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/13/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var tranferCoin: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var userInfo: UIButton!
    
    override func viewDidLoad() {
        FujiSDK.initialize()

    }
    
    @IBAction func login(_ sender: Any) {
        Logger.log(string: "test login")
        
        FujiSDK.login(viewController: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        func callback (isSuccess: Bool, message: String) {
            if(isSuccess){
                Toast.show(context: self.view, text: Constant.LOGOUT_SUCCESS)
            } else {
                Toast.show(context: self.view, text: Constant.LOGOUT_FAIL)
            }
        }
        
        
        FujiSDK.logout(viewController: self, callback1: callback)
    }
    
    
    @IBAction func userInfo(_ sender: Any) {
        FujiSDK.userInfo(viewController: self)
        
    }
    
    
    @IBAction func tranferCoin(_ sender: Any) {
        FujiSDK.tranferCoin(viewController: self, packageCode: "jp.co.alphapolis.games.remon.5")
    }
    

}








