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
    private static let API_LOGOUT_URL: String = "\(Constant.API_URL)user/logout"
    private static var currentUser: User? = nil
    
    private static let USER_NAME_JSON_KEY = "username"
    private static let USER_PASSWORD_JSON_KEY = "password"
    private static let PRODUCT_CODE_JSON_KEY = "productCode"
    private static let TOKEN_JSON_KEY = "token"
    private static let UID_JSON_KEY = "uid"
    
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
    
    class func loadSession() {
        let isLoggined = UserDefaults.standard.string(forKey: TOKEN_JSON_KEY) != nil
        
        if isLoggined {
            let username = UserDefaults.standard.string(forKey: USER_NAME_JSON_KEY)!
            let password = UserDefaults.standard.string(forKey: USER_PASSWORD_JSON_KEY)!
            let token = UserDefaults.standard.string(forKey: TOKEN_JSON_KEY)!
            
            currentUser = User.init(username: username, password: password, token: token)
            
        }
        
    }
    
    class public func login(user: User, callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        
        Logger.log(string: "login function")
        
        
        let parameters : Parameters = [USER_NAME_JSON_KEY: user.getUsername(),
                                       USER_PASSWORD_JSON_KEY: user.getPassword(),
                                       PRODUCT_CODE_JSON_KEY: Constant.PRODUCT_CODE]
        
        
        Alamofire.request(API_LOGIN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate().responseJSON { response in
                
            Logger.log(string: response.debugDescription)
                
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let token = json[TOKEN_JSON_KEY].stringValue
                
                Logger.log(string: "Login Successful: \(token)")
                
                user.setToken(token: token)
                currentUser = user
                
                UserDefaults.standard.set(currentUser?.getUsername(), forKey: USER_NAME_JSON_KEY)
                UserDefaults.standard.set(currentUser?.getPassword(), forKey: USER_PASSWORD_JSON_KEY)
                UserDefaults.standard.set(currentUser?.getToken(), forKey: TOKEN_JSON_KEY)
                
                callback(true, "OK")
                
            case .failure(let error):
                callback(false, "OK")
                Logger.log(string: error.localizedDescription)
                print(error)
            }
        }
    }
    
    class func isLoggedId() -> Bool {
        return currentUser != nil
    }
    
    class func logout(callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        let parameters : Parameters = [TOKEN_JSON_KEY: currentUser!.getToken(),
                                       UID_JSON_KEY: currentUser!.getUsername()]
        
        Alamofire.request(API_LOGOUT_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate().responseJSON { response in
                
                Logger.log(string: response.debugDescription)
                
                switch response.result {
                case .success:
                    
                    UserDefaults.standard.removeObject(forKey: USER_NAME_JSON_KEY)
                    UserDefaults.standard.removeObject(forKey: USER_PASSWORD_JSON_KEY)
                    UserDefaults.standard.removeObject(forKey: TOKEN_JSON_KEY)
                    User.currentUser = nil
                    
                    callback(true, "OK")
                    
                case .failure(let error):
                    callback(false, "OK")
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
}
