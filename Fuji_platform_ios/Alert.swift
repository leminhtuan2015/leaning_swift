//
//  Alert.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    class func confirm(viewController: UIViewController, message: String, callback: @escaping (_ isOk: Bool) -> Void){
        let alertController = UIAlertController(title: Constant.CONFIRM, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            callback(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            callback(false)
        }))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func show(viewController: UIViewController, message: String, callback: @escaping () -> Void = {}){
        let alert = UIAlertController(title: Constant.NOTICE, message: message,preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: Constant.OK, style: UIAlertActionStyle.default) {
            UIAlertAction in
            callback()
        }
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
