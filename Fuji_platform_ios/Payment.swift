//
//  Payment.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/9/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Payment {
    
    public static let PRODUCT_CODE: String = "RMReMonster" // GAME ID
    public static let PAYMENT_TYPE_FCOIN: String = "FCOIN" // PAYMENT TYPE
    public static let PAYMENT_TYPE_TELCO: String = "TELCO" // PAYMENT TYPE
    
    private static let DATA_JSON_KEY = "data"
    private static let PRODUCT_CODE_JSON_KEY = "productCode"
    private static let TOKEN_JSON_KEY = "token"
    private static let SERVER_CODE_JSON_KEY = "serverCode"
    private static let PACKAGE_CODE_JSON_KEY = "packageCode"
    private static let PAYMENT_TELCO_JSON_KEY = "paymentTelco" // VIETTEL, MOBILE, VINA
    private static let PAYMENT_TYPE_JSON_KEY = "paymentType"
    private static let COIN_TRANSFER_JSON_KEY = "coinTransfer"
    private static let HASH_JSON_KEY = "hash"
    private static let SECRET_KEY_JSON_KEY = "secretkey"
    
    private static let API_URL_SERVER_CODE: String = "\(Constant.API_URL)payment/serverCode"
    private static let API_URL_TRANFER: String = "\(Constant.API_URL)payment/transfer"
    
    private var token: String?
    private var serverCode: String? // SERVER ID
    private var packageCode: String?
    private var productCode: String?
    private var paymentTelco: String?
    private var paymentType: String? // TELCO, FCOIN
    private var coinTransfer: Int = 0
    
    init(token: String?, serverCode: String?, packageCode: String?, productCode: String?, paymentTelco: String?, paymentType: String?, coinTransfer: Int) {
        self.token = token
        self.serverCode = serverCode
        self.packageCode = packageCode
        self.productCode = productCode
        self.paymentTelco = paymentTelco
        self.paymentType = paymentType
        self.coinTransfer = coinTransfer
    }
    
    public func getToken() -> String {
        return self.token!
    }
    
    public func getServerCode() -> String {
        return serverCode!
    }
    
    public func getPackageCode() -> String {
        return self.packageCode!
    }
    
    public func getProductCode() -> String {
        return self.productCode!
    }
    
    public func getPaymentTelco() -> String {
        return self.paymentTelco!
    }
    
    public func getPaymentType() -> String {
        return self.paymentType!
    }
    
    public func getCoinTransfer() -> Int {
        return self.coinTransfer
    }
    
    public func getHash() -> String {
        let string = "\(Payment.COIN_TRANSFER_JSON_KEY)=\(getCoinTransfer())&\(Payment.PACKAGE_CODE_JSON_KEY)=\(getPackageCode())&\(Payment.PAYMENT_TELCO_JSON_KEY)=\(getPaymentTelco())&\(Payment.PAYMENT_TYPE_JSON_KEY)=\(getPaymentType())&\(Payment.PRODUCT_CODE_JSON_KEY)=\(getProductCode())&\(Payment.SERVER_CODE_JSON_KEY)=\(getServerCode())&\(Payment.TOKEN_JSON_KEY)=\(getToken())&\(Payment.SECRET_KEY_JSON_KEY)=\(getProductCode())"
        
        let md5 = string.md5()
//        "coinTransfer="+coinTransfer+"&packageCode="+packageCode+"&paymentTelco="+paymentTelco+"&paymentType="+paymentType+"&productCode="+productCode+"&serverCode="+serverCode+"&token="+tokenId+"&secretkey="+productCode;
        
        return md5
    }
    
    
    class public func getServerCode(productCode: String, callback: @escaping (_ isSuccess: Bool, _ message: String, _ serverCodes: [String]) -> Void) {
        let parameters : Parameters = [PRODUCT_CODE_JSON_KEY: productCode]
        
        Alamofire.request(API_URL_SERVER_CODE, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
//                Logger.log(string: response.debugDescription)
                
                switch response.result {
                case .success(let value):
                    
                    var serverCodes = [String]()
                    
                    let json = JSON(value)
                    let data = json[DATA_JSON_KEY].arrayValue
                    
//                    Logger.log(string: data.debugDescription)
                    
                    for serverCodeData in data {
                        let serverCode = serverCodeData.stringValue
                        
                        serverCodes.append(serverCode)
                    }
                    
                      callback(true, Constant.SUCCESS, serverCodes)
        
                case .failure(let error):
                      callback(false, Constant.SOMETHING_WENT_WRONG, [])
        
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class public func transfer(payment: Payment, callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        let parameters : Parameters = [TOKEN_JSON_KEY: payment.getToken(),
                                       SERVER_CODE_JSON_KEY: payment.getServerCode(),
                                       PRODUCT_CODE_JSON_KEY: payment.getProductCode(),
                                       PACKAGE_CODE_JSON_KEY: payment.getPackageCode(),
                                       PAYMENT_TELCO_JSON_KEY: payment.getPaymentTelco(),
                                       PAYMENT_TYPE_JSON_KEY: payment.getPaymentType(),
                                       COIN_TRANSFER_JSON_KEY: payment.getCoinTransfer(),
                                       HASH_JSON_KEY: payment.getHash()
        
        ]
        
//        Logger.log(string: parameters.description)
        
        Alamofire.request(API_URL_TRANFER, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
//                    Logger.log(string: json.description)
                    callback(true, Constant.SUCCESS)
                    
                case .failure(let error):
                      callback(false, Constant.SOMETHING_WENT_WRONG)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class public func pay(){
        
    }
}












