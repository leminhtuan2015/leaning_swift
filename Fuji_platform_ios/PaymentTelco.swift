//
//  PaymentTelco.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/10/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PaymentTelco {
    
    private static let API_URL_PAY: String = "\(Constant.API_URL)payment/pay"
    private static let API_URL_TELCO_TYPE: String = "\(Constant.API_URL)payment/detailByProduct"
    
    private static let PRODUCT_CODE_JSON_KEY = "productCode"
    private static let TOKEN_JSON_KEY = "token"
    private static let TELCO_CODE_JSON_KEY = "telcoCode"
    private static let CARD_ID_CODE_JSON_KEY = "cardId"
    private static let CARD_CODE_JSON_KEY = "cardCode"
    private static let DATA_JSON_KEY = "data"

    private var productCode: String?
    private var token: String?
    private var telcoCode: String?
    private var cardId: String?
    private var cardCode: String?
    
    init() {
    }
    
    init(productCode: String, token: String, telcoCode: String, cardId: String, cardCode: String) {
        self.productCode = productCode
        self.token = token
        self.telcoCode = telcoCode
        self.cardId = cardId
        self.cardCode = cardCode
    }
    
    public func getProductCode() -> String? {
        return self.productCode
    }
    
    public func getToken() -> String? {
        return self.token
    }
    
    public func getTelcoCode() -> String? {
        return self.telcoCode
    }
    
    public func getCardId() -> String? {
        return self.cardId
    }
    
    public func getCardCode() -> String? {
        return self.cardCode
    }
    
    public func setProductCode(productCode: String) {
        self.productCode = productCode
    }
    
    public func setToken(token: String) {
        self.token = token
    }
    
    public func setTelcoCode(telcoCode: String) {
        self.telcoCode = telcoCode
    }
    
    public func setCardId(cardId: String) {
        self.cardId = cardId
    }
    
    public func setCardCode(cardCode: String) {
        self.cardCode = cardCode
    }
    
    class public func pay(payment: PaymentTelco, callback: @escaping (_ isSuccess: Bool, _ message: String) -> Void){
        let parameters : Parameters = [PRODUCT_CODE_JSON_KEY: payment.getProductCode()!,
                                       TOKEN_JSON_KEY: payment.getToken()!,
                                       TELCO_CODE_JSON_KEY: payment.getTelcoCode()!,
                                       CARD_ID_CODE_JSON_KEY: payment.getCardId()!,
                                       CARD_CODE_JSON_KEY: payment.getCardCode()!
            
        ]
        
        //Logger.log(string: parameters.description)
        
        Alamofire.request(API_URL_PAY, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    Logger.log(string: json.description)
                    
                    if json["status"].stringValue == "NOK" {
                        callback(false, json["message"].stringValue)
                    } else {
                        callback(true, Constant.SUCCESS)
                    }
                    
                case .failure(let error):
                    callback(false, Constant.SOMETHING_WENT_WRONG)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
    class public func getTelcoesType(productCode: String, callback: @escaping (_ isSuccess: Bool, _ message: String, _ data: [String]?) -> Void){
        let parameters : Parameters = [PRODUCT_CODE_JSON_KEY: productCode]
        
        Alamofire.request(API_URL_TELCO_TYPE, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    var telcoTypes: [String] = []
                    
                    let json = JSON(value)
                    
                    let data = json[DATA_JSON_KEY].arrayValue
                    
                    for telcoType in data {
                        let telco = telcoType.stringValue
                        
                        telcoTypes.append(telco)
                    }

                    Logger.log(string: telcoTypes.description)
                    callback(true, Constant.SUCCESS, telcoTypes)
                    
                case .failure(let error):
                    callback(false, Constant.SOMETHING_WENT_WRONG, nil)
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
}
