//
//  Utils.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CryptoSwift
import SystemConfiguration

class Utils {
    
    class func sha256(string: String) -> String{
        return string.sha256()
    }
    
    class func isOnline() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    class func humanDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let humanDate = dateFormatter.string(from: date)
        
        return humanDate
    }
    
    class func humanDate(dateString1: String) -> String {
        Logger.log(string: dateString1)
        
        if !dateString1.isEmpty {
            //        let dateString = "Wed Jan 14 00:08:00 2015"
            
            let dateString = dateString1.replacingOccurrences(of: "ICT", with: "")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM dd HH:mm:ss yyyy"
            let dateFromString: Date? = formatter.date(from: dateString)
            
            formatter.dateFormat = "yyyy/MM/dd"
            let stringFromDate: String = formatter.string(from: dateFromString!)
            
            return stringFromDate
        }
        
        return ""
    }
}











