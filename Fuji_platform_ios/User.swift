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
    private static var currentUser: User? = nil
    
    private static let API_LOGIN_URL: String = "\(Constant.API_URL)user/login"
    private static let API_LOGOUT_URL: String = "\(Constant.API_URL)user/logout"
    private static let API_REGISTER_URL: String = "\(Constant.API_URL)user/register"
    private static let API_FORGOT_PASSWORD_URL: String = "\(Constant.API_URL)user/forgotPassword"
    private static let API_USER_INFO_URL: String = "\(Constant.API_URL)user/info"
    private static let API_UPDATE_INFO_URL: String = "\(Constant.API_URL)user/updateinfo"
    private static let API_UPDATE_PASSWORD_URL: String = "\(Constant.API_URL)user/changePassword"
    
    private static let USER_NAME_JSON_KEY = "username"
    private static let NEW_USER_NAME_JSON_KEY = "newUsername"
    private static let USER_PASSWORD_JSON_KEY = "password"
    private static let PRODUCT_CODE_JSON_KEY = "productCode"
    private static let EMAIL_JSON_KEY = "email"
    private static let TOKEN_JSON_KEY = "token"
    private static let UID_JSON_KEY = "uid"
    private static let FULL_NAME_JSON_KEY = "fullname"
    private static let ID_CARD_JSON_KEY = "idcard"
    private static let CARD_DATE_JSON_KEY = "card_date"
    private static let TELEPHONE_NUMBER_JSON_KEY = "telephonenumber"
    private static let FCOIN_JSON_KEY = "fcoin"
    private static let BIRTHDAY_JSON_KEY = "birthday"
    private static let MAIL_JSON_KEY = "mail"
    private static let CN_JSON_KEY = "cn" // fullname
    private static let CURRENT_PASSWORD_JSON_KEY = "passwordCurrent"
    private static let NEW_PASSWORD_JSON_KEY = "passwordNew"
    
    private var username: String = ""
    private var email: String = ""
    private var password: String = ""
    private var token: String = ""
    private var expires_in: String = ""
    private var fullname: String = ""
    private var cmt: String = ""
    private var cmtDate: String = ""
    private var phoneNumber: String = ""
    private var dob: String = ""
    private var fcoin: String = ""
    
    
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
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
    
    public static func getCurrentUser() -> User {
        return self.currentUser!
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
    
    public func getEmail() -> String{
        return self.email
    }
    
    public func setEmail(email: String){
        self.email = email
    }
    
    public func getFullname() -> String{
        return self.fullname
    }
    
    public func setFullname(fullname: String){
        self.fullname = fullname
    }
    
    public func getCMT() -> String{
        return self.cmt
    }
    
    public func setCMT(cmt: String){
        self.cmt = cmt
    }
    
    public func getCMTDate() -> String{
        return self.cmtDate
    }
    
    public func setCMTDate(cmtDate: String){
        if cmtDate == "null" {
            
            self.cmtDate = ""
            return
        }
        self.cmtDate = cmtDate
    }
    
    public func getPhoneNumber() -> String{
        return self.phoneNumber
    }
    
    public func setPhoneNumber(phoneNumber: String){
        self.phoneNumber = phoneNumber
    }
    
    public func getDOB() -> String{
        return self.dob
    }
    
    public func setDOB(dob: String){
        if dob == "null" {
            self.dob = ""
            
            return
        }
        
        self.dob = dob
    }
    
    public func getFcoin() -> String{
        return self.fcoin
    }
    
    public func setFcoin(fcoin: String){
        self.fcoin = fcoin
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
    
    class func updateSession(password: String) {
        UserDefaults.standard.set(password, forKey: USER_PASSWORD_JSON_KEY)
        
        currentUser?.setPassword(password: password)
        
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
    
    class func isLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    class func logout(callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        let parameters : Parameters = [TOKEN_JSON_KEY: currentUser!.getToken(),
                                       UID_JSON_KEY: currentUser!.getUsername()]
        
        Alamofire.request(API_LOGOUT_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate().responseJSON { response in
                
//                Logger.log(string: response.debugDescription)
                
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
    
    class func signup(user: User, callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void) {
        let parameters : Parameters = [NEW_USER_NAME_JSON_KEY: user.getUsername(),
                                       EMAIL_JSON_KEY: user.getEmail(),
                                       USER_PASSWORD_JSON_KEY: user.getPassword()
                                    ]
        
        Alamofire.request(API_REGISTER_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                Logger.log(string: response.debugDescription)
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    Logger.log(string: json.description)
                
                    callback(true, Constant.SIGNUP_SUCCESS)
                    
                case .failure(let error):
                    callback(false, Constant.USERNAME_OR_EMAIL_IS_EXISTS)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class func forgotPassword(email: String, callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        
        let parameters : Parameters = [EMAIL_JSON_KEY: email]

        
        Alamofire.request(API_FORGOT_PASSWORD_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    callback(true, Constant.FORGOT_PASWORD_SUCCESS)
                    
                case .failure(let error):
                    callback(false, Constant.EMAIL_NOT_EXISTS)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class func getUserInfo(token: String, callback: @escaping (_ isSuccess: Bool, _ message: String, _ user: User?) -> Void) {
        
        let parameters : Parameters = [TOKEN_JSON_KEY: token]
        
        
        Alamofire.request(API_USER_INFO_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    Logger.log(string: json.description)
                    
                    let user: User? = User()
                    
                    user?.setUsername(username: json[User.UID_JSON_KEY].stringValue)
                    user?.setEmail(email: json[User.MAIL_JSON_KEY].stringValue)
                    
                    user?.setFullname(fullname: json[User.CN_JSON_KEY].stringValue)
                    user?.setCMT(cmt: json[User.ID_CARD_JSON_KEY].stringValue)
                    user?.setCMTDate(cmtDate: json[User.CARD_DATE_JSON_KEY].stringValue)
                    user?.setPhoneNumber(phoneNumber: json[User.TELEPHONE_NUMBER_JSON_KEY].stringValue)
                    user?.setDOB(dob: json[User.BIRTHDAY_JSON_KEY].stringValue)
                    user?.setFcoin(fcoin: json[User.FCOIN_JSON_KEY].stringValue)
                    
                    callback(true, Constant.FORGOT_PASWORD_SUCCESS, user)
                    
                case .failure(let error):
                    callback(false, Constant.SOMETHING_WENT_WRONG, nil)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class func update(user: User, callback: @escaping (_ isSuccess: Bool, _ message: String, _ user: User?) -> Void) {
        
        let parameters : Parameters = [ TOKEN_JSON_KEY: user.getToken(),
                                        FULL_NAME_JSON_KEY: user.getFullname(),
                                        TELEPHONE_NUMBER_JSON_KEY: user.getPhoneNumber(),
                                        ID_CARD_JSON_KEY: user.getCMT(),
                                        CARD_DATE_JSON_KEY: user.getCMTDate()
                                        
        ]
        
        Logger.log(string: parameters.description)
        
        Alamofire.request(API_UPDATE_INFO_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                Logger.log(string: response.debugDescription)
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    Logger.log(string: json.description)
                    
                    callback(true, Constant.SUCCESS, user)
                    
                case .failure(let error):
                    callback(false, Constant.SOMETHING_WENT_WRONG, nil)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class func updatePassword(newPassword: String, user: User, callback: @escaping (_ isSuccess: Bool, _ message: String, _ user: User?) -> Void) {
        
        let parameters : Parameters = [ TOKEN_JSON_KEY: user.getToken(),
                                        CURRENT_PASSWORD_JSON_KEY: user.getPassword(),
                                        NEW_PASSWORD_JSON_KEY: newPassword
            
        ]
        
        Logger.log(string: parameters.description)
        
        Alamofire.request(API_UPDATE_PASSWORD_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                Logger.log(string: response.debugDescription)
                
                switch response.result {
                case .success(let value):
                    
                    user.setPassword(password: newPassword)
                    
                    callback(true, Constant.SUCCESS, user)
                    
                case .failure(let error):
                    callback(false, Constant.SOMETHING_WENT_WRONG, nil)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
}
