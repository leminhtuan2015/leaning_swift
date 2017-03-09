//
//  PaymentViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/9/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class PaymentViewController: BasicViewController {
    
    private var packageCode: String?
    private var serverCodes: [String]? = nil
    private var packages: [Package]? = nil
    private var packageBuying: Package? = nil
    private var user: User? = nil
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    @IBOutlet weak var labelCurrentCoin: UILabel!
    
    @IBOutlet weak var buttonBuyByFcoin: UIButton!
    @IBOutlet weak var labelMessage: UILabel!
    
    
    @IBAction func buttonBuyByCoin(_ sender: Any) {
        buyByFcoin()
    }
    
    @IBAction func buttonBuyByCard(_ sender: Any) {
        buyByCard()
    }
    
    @IBOutlet weak var buttonBuyByCard: UIButton!
    
    override func viewDidLoad() {
        
        if(!User.isLoggedIn()){
            Toast.show(context: self.view, text: Constant.NOT_LOGGED_IN)
            return
        }
        
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
        
        prepareData()
    }
    
    private func prepareData(){
        func callbackGetPackage(isSuccess: Bool, message: String, packages: [Package]){
            if isSuccess {
//                Logger.log(string: packages.description)
                
                self.packages = packages
                
                packageBuying = Package.getPackageByPackageCode(packageCode: self.packageCode!, packages: self.packages!)
                
                renderView()
            } else {
                Toast.show(context: self.view, text: message)
            }
            
        }
        
        func callbackGetServerCodes(isSuccess: Bool, message: String, serverCodes: [String]){
            if isSuccess {
//                Logger.log(string: serverCodes.description)
                
                self.serverCodes = serverCodes
            } else {
                Toast.show(context: self.view, text: message)
            }
        }
        
        Payment.getServerCode(productCode: Payment.PRODUCT_CODE, callback: callbackGetServerCodes)
        Package.getPackages(productCode: Payment.PRODUCT_CODE, callback: callbackGetPackage)
    }
    
    private func renderView(){
        
        func callback(isSuccess: Bool, message: String, user: User?) {
            if isSuccess {
                
                self.user = user
                let currentCoint = (user?.getFcoin())!
                
                labelCurrentCoin.text = "\(Constant.CURRENT_COIN) \(currentCoint) \(Constant.FCOIN)"
                
                if packageBuying == nil {
                    labelMessage.text = Constant.NOT_EXIST
                    buttonBuyByCard.isEnabled = false
                    buttonBuyByFcoin.isEnabled = false
                    
                } else {
                    let packageCoin = packageBuying?.getFcoinMinus()
                    labelMessage.text = "\(Constant.BUYING_PACKAGE) \(packageCoin!) \(Constant.FCOIN)"
                }
                
            } else {
                Toast.show(context: self.view, text: message)
            }
        }
        
        User.getUserInfo(token: User.getCurrentUser().getToken(), callback: callback)
        
    }
    
    private func buyByFcoin(){
        let myCurrentCoin: Int = Int((self.user?.getFcoin())!)!
        
        if myCurrentCoin < (packageBuying?.getFcoinMinus())! {
            buyByCard()
            
            return
        }
        
        let payment: Payment = Payment.init(token: User.getCurrentUser().getToken(),
                                            serverCode: self.serverCodes?.first,
                                            packageCode: packageBuying?.getPackageCode(),
                                            productCode: Payment.PRODUCT_CODE,
                                            paymentTelco: "",
                                            paymentType: Payment.PAYMENT_TYPE_FCOIN,
                                            coinTransfer: (packageBuying?.getFcoinMinus())!)
        
        func callback(isSuccess: Bool, message: String) {
            
            Indicator.stop()
            
            if isSuccess {
                Toast.show(context: self.view, text: message)
                
                navigationController?.popViewController(animated: true)
                
            } else {
                Toast.show(context: self.view, text: message)
            }
        }
        
        Indicator.start(context: self.view)
        
        Payment.transfer(payment: payment, callback: callback)
        
    }
    
    private func buyByCard() {
        Logger.log(string: "Buy by card")
        
    }
    
    public func setPackageCode(packageCode: String){
        self.packageCode = packageCode
    }
}
