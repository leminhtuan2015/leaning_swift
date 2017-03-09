//
//  Package.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/9/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Package {
    private static let API_URL_PACKAGE_CODE: String = "\(Constant.API_URL)payment/package"
    
    private static let DATA_JSON_KEY = "data"
    private static let PRODUCT_CODE_JSON_KEY = "productCode"
    private static let PACKAGE_ID_JSON_KEY = "packageId"
    private static let PACKAGE_CODE_JSON_KEY = "packageCode"
    private static let FCOIN_MINUS_JSON_KEY = "fcoinMinus"
    private static let PACKAGE_NAME_JSON_KEY = "packageName"
    
    private var fcoinMinus: Int?;
    private var packageCode: String?;
    private var packageId: Int?;
    private var packageName: String?;
    
    init(packageId: Int, packageName: String, packageCode: String, fcoinMinus: Int) {
        self.fcoinMinus = fcoinMinus
        self.packageCode = packageCode
        self.packageId = packageId
        self.packageName = packageName
    }
    
    public func getPackageCode() -> String {
        return self.packageCode!
    }
    
    public func getPackageId() -> Int {
        return self.packageId!
    }
    
    public func getPackageName() -> String {
        return self.packageName!
    }
    
    public func getFcoinMinus() -> Int {
        return self.fcoinMinus!
    }
    
    
    public class func getPackageByPackageCode(packageCode: String, packages: [Package]) -> Package? {
        for package in packages {
            if package.getPackageCode() == packageCode {
                return package
            }
        }
        
        return nil
    }
    
    public class func getPackages(productCode: String, callback: @escaping (_ isSuccess: Bool, _ message: String, _ packages: [Package]) -> Void) {
        let parameters : Parameters = [PRODUCT_CODE_JSON_KEY: productCode]
        
        Alamofire.request(API_URL_PACKAGE_CODE, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                
//                Logger.log(string: response.debugDescription)
                
                switch response.result {
                case .success(let value):
                    
                    var packages = [Package]()
                    
                    let json = JSON(value)
//                    Logger.log(string: json.debugDescription)
                    let data = json[DATA_JSON_KEY].arrayValue
//                    Logger.log(string: data.debugDescription)
                    
                    for packageData in data {
//                    Logger.log(string: packageData.debugDescription)
                        
                        let packageId = packageData[PACKAGE_ID_JSON_KEY].intValue
                        let packageCode = packageData[PACKAGE_CODE_JSON_KEY].stringValue
                        let fcoinMinus = packageData[FCOIN_MINUS_JSON_KEY].intValue
                        let packageName = packageData[PACKAGE_NAME_JSON_KEY].stringValue
                        
                        let package = Package.init(packageId: packageId, packageName: packageName, packageCode: packageCode, fcoinMinus: fcoinMinus)
                        
                        packages.append(package)
                    }
                    
                    callback(true, Constant.SUCCESS, packages)
                    
                case .failure(let error):
                    callback(false, Constant.SOMETHING_WENT_WRONG, [])
                    
                    Logger.log(string: error.localizedDescription)
                }
        }
    }
    
}
