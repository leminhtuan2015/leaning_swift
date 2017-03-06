//
//  ViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import UIKit

class HomeViewController: BasicViewController {
    
    public var x = 0
    
    @IBOutlet weak var buttonLogin: UIButton!

    @IBAction func buttonLogin(_ sender: Any) {
        Logger.log(string: "Login")
        
        self.performSegue(withIdentifier: Constant.SEGUE_LOGIN, sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log(string: "xxxxxx: \(x)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

