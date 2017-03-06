//
//  User.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class User {
    private static let API_LOGIN_URL: String = "\(Constant.API_URL)user/login"
    private static var me: User = User()
    
    private var username: String = ""
    private var password: String = ""
    private var token: String = ""
    private var expires_in: String = ""
    
    init() {}
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init(username: String, password: String, token: String) {
        self.username = username
        self.password = password
        self.token = token
    }
    
    public func getUsername() -> String {
        return self.username
    }
    
    public func setUsername(username: String) {
        self.username = username
    }
    
    public func getPassword() -> String {
        return self.password
    }
    
    public func setPassword(password: String){
        self.password = password
    }
    
    public func getToken() -> String {
        return self.token
    }
    
    public func setToken(token: String) {
        self.token = token
    }
    
    public func getExpires_in() -> String{
        return self.expires_in
    }
    
    public func setExpires_in(expires_in: String){
        self.expires_in = expires_in
    }
    
    class public func login(user: User, callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        
        Logger.log(string: "login function")
        
        
        let parameters : Parameters = ["username": user.getUsername(),
                                       "password": user.getPassword(),
                                       "productCode": Constant.PRODUCT_CODE
                                    ]
        
        
        Alamofire.request(API_LOGIN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate().responseJSON { response in
                
            Logger.log(string: response.debugDescription)
                
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let token = json["token"].stringValue
                
                Logger.log(string: "Login Successful: \(token)")
                
                user.setToken(token: token)
                me = user
                
                callback(true, "OK")
                
            case .failure(let error):
                callback(false, "OK")
                Logger.log(string: error.localizedDescription)
                print(error)
            }
        }
    }
    
}
