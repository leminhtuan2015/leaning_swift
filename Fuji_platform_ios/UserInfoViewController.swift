//
//  UserInfoViewController.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/8/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: BasicViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var username: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var cmt: UITextView!
    @IBOutlet weak var cmtDay: UITextView!
    @IBOutlet weak var fullname: UITextView!
    @IBOutlet weak var phone: UITextView!
    @IBOutlet weak var dob: UITextView!
    @IBOutlet weak var fcoin: UITextView!
    
    @IBAction func buttonChangePassword(_ sender: Any) {
        gotoUpdatePassword()
    }
    
    @IBAction func buttonUpdateUserInfo(_ sender: Any) {
        gotoUpdateUserInfo()
    }
    
    
    override func viewDidLoad() {
        imageViewLogo.image = UIImage(named: Constant.LOGO_IMAGE_NAME)
        self.title = Constant.USER_INFO_TITLE
        
        renderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        renderView()
    }
    
    private func renderView(){
        
        func callback(isSuccess: Bool, message: String, user: User?) {
            if isSuccess {
                username.text = user?.getUsername()
                email.text = user?.getEmail()
                fullname.text = user?.getFullname()
                cmt.text = user?.getCMT()
                cmtDay.text = user?.getCMTDate()
                phone.text = user?.getPhoneNumber()
                dob.text = user?.getDOB()
                fcoin.text = user?.getFcoin()
                
                User.getCurrentUser().setFullname(fullname: (user?.getFullname())!)
                User.getCurrentUser().setCMT(cmt: (user?.getCMT())!)
                User.getCurrentUser().setCMTDate(cmtDate: (user?.getCMTDate())!)
                User.getCurrentUser().setPhoneNumber(phoneNumber: (user?.getPhoneNumber())!)
                User.getCurrentUser().setDOB(dob: (user?.getDOB())!)
                User.getCurrentUser().setFcoin(fcoin: (user?.getFcoin())!)
            } else {
                Toast.show(context: self.view, text: message)
            }
        }
        
        User.getUserInfo(token: User.getCurrentUser().getToken(), callback: callback)
        
    }
    
    private func gotoUpdateUserInfo(){
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_UPDATE_USER_INFO_ID) as! UpdateUserInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gotoUpdatePassword(){
        let storyboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN_NAME, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constant.STORY_BOARD_UPDATE_PASSWORD_ID) as! UpdatePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
