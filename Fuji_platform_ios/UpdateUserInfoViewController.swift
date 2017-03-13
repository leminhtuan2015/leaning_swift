//
//  UpdateUserInfo.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/8/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit
import DatePickerDialog

class UpdateUserInfoViewController: BasicViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var CMT: UITextField!
    
    @IBOutlet weak var cmtDay: UITextField!
    
    @IBAction func buttonUpdate(_ sender: Any) {
        updateUserInfo()
    }
    
    override func viewDidLoad() {
        self.title = Constant.USER_UPDATE_INFO_TITLE
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
        
        fullname.delegate = self
        phoneNumber.delegate = self
        cmtDay.delegate = self
        CMT.delegate = self
        
        render()
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:true)
        
        if textField == cmtDay {
            
            CMT.endEditing(true)
            phoneNumber.endEditing(true)
            fullname.endEditing(true)
            
                    DatePickerDialog().show(title: "yyyy/mm/dd", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { (date) -> Void in
                        if date != nil && date?.description != "nil"{
                            Logger.log(string: (date?.description)!)
            
                            let humanDate = Utils.humanDate(date: date!)
            
                            textField.text = "\(humanDate)"
                        }
                        
                    }
        }
    }
    
    private func render(){
        fullname.text = User.getCurrentUser().getFullname()
        phoneNumber.text = User.getCurrentUser().getPhoneNumber()
        CMT.text = User.getCurrentUser().getCMT()
        cmtDay.text = User.getCurrentUser().getCMTDate()
    }
    
    private func updateUserInfo(){
        
        let (status, message, user) = validate()
        
        if !status {
            Toast.show(context: self.view, text: message)
            return
        }
        
        func callback(isSuccess: Bool, message: String, user: User?) {
            if isSuccess {
                Toast.show(context: self.view, text: message)
                
                navigationController?.popViewController(animated: true)
            } else {
                Toast.show(context: self.view, text: message)
            }
            
        }
        
        User.update(user: user!, callback: callback)
    
    }
    
    private func validate() -> (Bool, String, User?) {
        let fullnameText: String = (fullname.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let phoneNumberText: String = (phoneNumber.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let CMTText: String = (CMT.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let CMTDateText: String = (cmtDay.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        if fullnameText.isEmpty && phoneNumberText.isEmpty && CMTText.isEmpty && CMTDateText.isEmpty {
            return (false, Constant.MISSING_INFOMATION, nil)
        }
        
        let user: User = User()
        user.setToken(token: User.getCurrentUser().getToken())
        user.setFullname(fullname: fullnameText)
        user.setPhoneNumber(phoneNumber: phoneNumberText)
        user.setCMT(cmt: CMTText)
        user.setCMTDate(cmtDate: CMTDateText)
    
        return (true, "OK", user)
    }
}
