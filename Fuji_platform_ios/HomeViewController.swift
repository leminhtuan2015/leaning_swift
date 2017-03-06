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
        Logger.log(string: "Login")
        
        self.performSegue(withIdentifier: Constant.SEGUE_LOGIN, sender: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.loadSession()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.log(string: "Hello")
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        if User.isLoggedId() {
            buttonLogin.isEnabled = false
            buttonLogout.isEnabled = true
        } else {
            buttonLogin.isEnabled = true
            buttonLogout.isEnabled = false
        }
    }


}

