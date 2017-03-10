//
//  PaymentTelcoViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/10/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import UIKit

class PaymentTelcoViewController: BasicViewController {
    
    private var paymentTelco = PaymentTelco()
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var textfieldCardNumber: UITextField!
    @IBOutlet weak var textFieldCardSerial: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func buttonSubmit(_ sender: Any) {
        submit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
        self.title = Constant.PAYMENT_TELCO_TITLE
        
        textfieldCardNumber.delegate = self
        textFieldCardSerial.delegate = self
        
        prepareData()
    }
    
    private func prepareData(){
        
        func callback(isSuccess: Bool, message: String, data: [String]?){
            
            Indicator.stop()
            
            if isSuccess {
                renderButtonTelco(telcoTypes: data!)
            } else {
                Toast.show(context: self.view, text: message)
            }
            
        }
        
        Indicator.start(context: self.view)
        PaymentTelco.getTelcoesType(productCode: Payment.PRODUCT_CODE, callback: callback)
    }
    
    private func renderButtonTelco(telcoTypes: [String]){
        for telcoType in telcoTypes {
            let imageName = getImageNameByType(telcoType: telcoType, isDisabled: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            
            button.setImage(UIImage(named: imageName), for: UIControlState.normal)
            button.addTarget(self, action: #selector(clickedButtonTelcoType(sender:)), for: .touchUpInside)
            button.setTitle(telcoType, for: .normal)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func clickedButtonTelcoType(sender: UIButton){
        Logger.log(string: "oki: \(sender.currentTitle)")
        
        let telcoCode = sender.currentTitle
        
        paymentTelco.setTelcoCode(telcoCode: telcoCode!)
        
        for button in self.stackView.subviews {
            let b = button as! UIButton
            let imgName = getImageNameByType(telcoType: b.currentTitle!, isDisabled: true)
            b.setImage(UIImage(named: imgName), for: UIControlState.normal)
        }
        
        let imageName = getImageNameByType(telcoType: sender.currentTitle!, isDisabled: false)
        
        sender.setImage(UIImage(named: imageName), for: UIControlState.normal)
    }
    
    private func getImageNameByType(telcoType: String, isDisabled: Bool) -> String {
        
        var name = ""
        
        if telcoType == "VIETTEL" {
            name = "ic_viettel"
            
        } else if telcoType == "MOBIFONE" {
            name = "ic_mobiphone"
            
        } else if telcoType == "VINAPHONE"{
            name = "ic_vinaphone"
        }
        
        if isDisabled {
            name = "\(name)_disabled"
        }
        
        return name
    }
    
    private func submit(){
        
        let cardId = textfieldCardNumber.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let cardCode = textFieldCardSerial.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        paymentTelco.setProductCode(productCode: Payment.PRODUCT_CODE)
        paymentTelco.setToken(token: User.getCurrentUser().getToken())
        paymentTelco.setCardId(cardId: cardId!)
        paymentTelco.setCardCode(cardCode: cardCode!)
        
        let (isValid, message) = validate()
        
        if !isValid {
            Toast.show(context: self.view, text: message)
            
            return
        }
        
        func callback(isSuccess: Bool, message: String){
            
            Indicator.stop()
            
            if isSuccess {
                navigationController?.popViewController(animated: true)
            } else {
                Toast.show(context: self.view, text: message)
            }
        }
        
        Indicator.start(context: self.view)
        PaymentTelco.pay(payment: paymentTelco, callback: callback)
    }
    
    private func validate() -> (Bool, String) {
        if (paymentTelco.getCardId()?.isEmpty)! || (paymentTelco.getCardCode()?.isEmpty)! {
            return (false, Constant.MISSING_INFOMATION)
            
        } else if paymentTelco.getTelcoCode() == nil {
            return (false, Constant.CHOOSE_TELCO_TYPE)
        }
        
        return (true, Constant.OK)
    }
}










