//
//  ViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import UIKit

class HomeViewController: BasicViewController {
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!

    @IBAction func buttonLogin(_ sender: Any) {
        Logger.log(string: "Login 1")
        
        self.performSegue(withIdentifier: Constant.STORY_BOARD_SEGUE_LOGIN, sender: self)
        
        Logger.log(string: "Login 2")
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        func callback(isOk: Bool) {
            if isOk {
                Logger.log(string: "Ok Logout")
                
                func callback (isSuccess: Bool, message: String) {
                    if(isSuccess){
                        Toast.show(context: self.view, text: Constant.LOGOUT_SUCCESS)
                        
                        self.viewWillAppear(true)
                    } else {
                        Toast.show(context: self.view, text: Constant.LOGOUT_FAIL)
                    }
                }
                
                User.logout(callback: callback)
            }
            
        }
        Alert.confirm(viewController: self, message: Constant.LOGOUT_CONFIRM, callback: callback)
    }
    
    @IBAction func buttonUserInfo(_ sender: Any) {
        Logger.log(string: "UserInfo 1")
        self.performSegue(withIdentifier: Constant.STORY_BOARD_SEGUE_USER_INFO, sender: self)
        Logger.log(string: "UserInfo 2")
        
    }
    
    
    @IBOutlet weak var buttonTranferCoin: UIButton!
    
    @IBAction func buttonTranferCoin(_ sender: Any) {
        self.performSegue(withIdentifier: Constant.STORY_BOARD_SEGUE_TRANFER_COIN, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.loadSession()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        Logger.log(string: "SEGUE \(segue.identifier)")
        
        if segue.identifier == Constant.STORY_BOARD_SEGUE_TRANFER_COIN {
            let vc = segue.destination as! PaymentViewController
//            vc.setPackageCode(packageCode: "jp.co.alphapolis.games.remon.730")
            vc.setPackageCode(packageCode: "jp.co.alphapolis.games.remon.5")
        }
    }
    
    func setupView(){
        if User.isLoggedIn() {
            buttonLogin.isEnabled = false
            buttonLogout.isEnabled = true
        } else {
            buttonLogin.isEnabled = true
            buttonLogout.isEnabled = false
        }
    }


}

