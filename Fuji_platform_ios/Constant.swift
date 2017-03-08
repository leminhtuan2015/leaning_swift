//
//  Constant.swift
//  Fuji_platform_ios
//
//  Created by Fuji on 3/6/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import Foundation

class Constant {
    public static let API_URL: String = "http://sabina.vn:9000/"
    public static let PRODUCT_CODE: String = "RMReMonster"
    
    public static let STORY_BOARD_MAIN_NAME: String = "Main"
    public static let STORY_BOARD_LOGIN_ID: String = "LoginViewController"
    public static let STORY_BOARD_SIGNUP_ID: String = "SignupViewController"
    public static let STORY_BOARD_HOME_ID: String = "HomeViewController"
    public static let STORY_BOARD_FORGOT_PASSWORD_ID: String = "ForgotPasswordViewController"
    public static let STORY_BOARD_UPDATE_USER_INFO_ID: String = "UpdateUserInfoViewController"
    public static let STORY_BOARD_UPDATE_PASSWORD_ID: String = "UpdatePasswordViewController"
    
    public static let STORY_BOARD_SEGUE_LOGIN: String = "login"
    public static let STORY_BOARD_SEGUE_SIGNUP: String = "signup"
    public static let STORY_BOARD_SEGUE_FORGOT_PASSWORD: String = "ForgotPassword"
    public static let STORY_BOARD_SEGUE_USER_INFO: String = "UserInfo"
    
    public static let LOGO_IMAGE_NAME: String = "logo"
    public static let LOGIN_TITLE: String = "Đăng nhập"
    public static let SIGNUP_TITLE: String = "Đăng ký"
    public static let USER_INFO_TITLE: String = "Thông tin tài khoản"
    public static let USER_UPDATE_INFO_TITLE: String = "Cập nhật thông tin"
    public static let USER_UPDATE_PASSWORD_TITLE: String = "Thay đổi mật khẩu"
    
    public static let NOTICE: String = "Thông báo"
    public static let ERROR: String = "Lỗi"
    public static let SOMETHING_WENT_WRONG: String = "Có lỗi xảy ra, vui lòng thử lại"
    public static let USERNAME_OR_EMAIL_IS_EXISTS: String = "Có lỗi xảy ra, tên đăng nhập hoặc email đã tồn tại"
    public static let OK: String = "OK"
    public static let LOGIN_ERROR_MESSAGE: String = "Vui lòng điền đầy đủ thông tin đăng nhập"
    public static let LOGIN_SUCCESS: String = "Đăng nhập thành công"
    public static let SIGNUP_SUCCESS: String = "Đăng ký thành công"
    public static let LOGIN_FAIL: String = "Đăng nhập thất bại, vui lòng thử lại"
    public static let LOGOUT_SUCCESS: String = "Đăng xuất thành công"
    public static let LOGOUT_FAIL: String = "Đăng xuất thất bại, vui lòng thử lại"
    public static let LOGOUT_CONFIRM: String = "Bạn muốn đăng xuất hệ thống?"
    public static let CONFIRM: String = "Xác nhận"
    public static let MISSING_INFOMATION: String = "Vui lòng nhập đầy đủ tất cả thông tin"
    public static let IN_VALIDATE_USERNAME: String = "Tên đăng nhập từ 8-20 ký tự, bao gồm chữ cái, số và . _"
    public static let IN_VALIDATE_EMAIL: String = "Email không đúng định dạng"
    public static let PASSWORD_NOT_MATCHES: String = "Mật khẩu và mật khẩu xác nhận không trùng nhau"
    public static let YOU_ARE_OFFLINE: String = "Bạn đang offile, vui lòng kết nối Internet"
    public static let EMAIL_NOT_EXISTS: String = "Có lỗi xảy ra, email này không tồn tại trong hệ thống vui lòng nhập lại"
    public static let FORGOT_PASWORD_SUCCESS: String = "Thành công, vui lòng truy cập email để lấy mật khẩu"
    public static let SUCCESS: String = "Thành công"
    public static let CURRENT_PASSWORD_WRONG: String = "Mật khẩu hiện tại không chính xác"
    public static let NEW_PASSWORD_AND_NEW_PASWORD_CONFIRM_NOT_MATCHES: String = "Mật khẩu mới và mật khẩu mới nhập lại không trùng nhau"
    public static let NEW_PASSWORD_AND_OLD_PASSOWRD_MATCHES: String = "Mật khẩu mới và mật khẩu cũ không được trùng nhau"
    
    public static let REGULAR_EXPRESSION_USERNAME = "^([0-9a-zA-Z]|\\.|_){8,20}$"
    
}
