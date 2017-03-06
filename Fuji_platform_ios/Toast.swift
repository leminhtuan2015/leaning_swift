//
//  Toast.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

class Toast {
    class func show(context: UIView, text: String, duration: Float = -1) {
        var style = ToastStyle()
        
        style.backgroundColor = UIColor.gray.withAlphaComponent(0.9)
        style.fadeDuration = TimeInterval(3.0)
        
        ToastManager.shared.tapToDismissEnabled = true
        
        var durationAuto = duration
        
        if duration < 0 {
            durationAuto = Float(text.components(separatedBy: " ").count) / 3
        }
        
        context.makeToast(text, duration: TimeInterval(durationAuto), position: .center, style: style)
    }
}

