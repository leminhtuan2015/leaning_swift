//
//  Indicator.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Indicator {
    
    private static var activityIndicatorView: NVActivityIndicatorView? = nil
    
    class func start(context: UIView) {
        Indicator.stop()
        
        let frame = CGRect(x: context.center.x - 25, y: context.center.y - 25, width: 50, height: 50)
        
        activityIndicatorView = NVActivityIndicatorView(
            frame: frame,
            type: NVActivityIndicatorType.ballRotateChase,
            color: UIColor.gray)
        
        context.addSubview(activityIndicatorView!)
        
        activityIndicatorView!.startAnimating()
    }
    
    class func stop(){
        if activityIndicatorView != nil {
            activityIndicatorView?.stopAnimating()
        }
    }
}
