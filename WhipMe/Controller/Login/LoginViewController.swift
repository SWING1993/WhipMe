//
//  LoginViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {

    var textNickname: UITextField!
    var textPassword: UITextField!
    var btnSubmit: UIButton!
    var btnRegister: UIButton!
    var btnAgreement: UIButton!
    var verify_codeBtn: PhoneCodeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "手机登陆"
        self.view.backgroundColor = Define.kColorBackGround()
        
        WMUploadFile.isNeedRequestToGetDomain()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setup() {
        
        let texts: NSArray = ["请输入手机号码","请输入验证码"]
        var origin_y: CGFloat = 15.0
        for itemStr in texts {
            let itemText: UITextField = UITextField.init()
            itemText.backgroundColor = UIColor.white
            itemText.font = kContentFont
            itemText.textAlignment = NSTextAlignment.left
            itemText.textColor = Define.kColorBlack()
            itemText.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            itemText.clearButtonMode = UITextFieldViewMode.whileEditing
            itemText.keyboardType = UIKeyboardType.numberPad
            itemText.placeholder = itemStr as? String
            itemText.layer.cornerRadius = 4.0
            itemText.layer.masksToBounds = true
            itemText.delegate = self
            self.view.addSubview(itemText)
            
            let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10.0, height: 0))
            viewLeft.backgroundColor = UIColor.clear
            itemText.leftView = viewLeft
            itemText.leftViewMode = UITextFieldViewMode.always
            
            if itemStr as? String == "请输入手机号码" {
                textNickname = itemText
                itemText.snp.updateConstraints({ (make) in
                    make.width.equalTo(Define.screenWidth() - 36.0)
                    make.height.equalTo(44.0)
                    make.centerX.equalTo(self.view)
                    make.top.equalTo(origin_y)
                })
            } else {
                textPassword = itemText
                itemText.snp.updateConstraints({ (make) in
                    make.width.equalTo(Define.screenWidth() - 142.0)
                    make.height.equalTo(44.0)
                    make.left.equalTo(self.view).offset(18.0)
                    make.top.equalTo(origin_y)
                })
                
                let rect_button = CGRect.init(x: 0, y: 0, width: 90.0, height: 44.0)
                verify_codeBtn = PhoneCodeButton.init(type: UIButtonType.custom)
                verify_codeBtn.backgroundColor = Define.kColorYellow()
                verify_codeBtn.layer.cornerRadius = 4.0
                verify_codeBtn.layer.masksToBounds = true
                verify_codeBtn.adjustsImageWhenHighlighted = false
                verify_codeBtn.titleLabel?.font = kTitleFont
                verify_codeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                verify_codeBtn.setTitle("获取验证码", for: UIControlState.normal)
                verify_codeBtn.addTarget(self, action: #selector(clickWithCode(sender:)), for: UIControlEvents.touchUpInside)
                self.view.addSubview(verify_codeBtn)
                verify_codeBtn.snp.updateConstraints({ (make) in
                    make.size.equalTo(rect_button.size)
                    make.right.equalTo(self.view).offset(-18.0)
                    make.top.equalTo(itemText)
                })
            }
            
            origin_y += 64.0
        }
        
        let rect_submit = CGRect.init(x: 0, y: 0, width: Define.screenWidth() - 40.0, height: 44.0)
        btnSubmit = UIButton.init(type: UIButtonType.custom)
        btnSubmit.setBackgroundImage(UIImage.imageWithDraw(Define.kColorCyanOff(), sizeMake: rect_submit), for: UIControlState.normal)
        btnSubmit.setBackgroundImage(UIImage.imageWithDraw(Define.kColorCyanOn(), sizeMake: rect_submit), for: UIControlState.highlighted)
        btnSubmit.titleLabel?.font = kButtonFont
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnSubmit.layer.cornerRadius = 4.0
        btnSubmit.layer.masksToBounds = true
        btnSubmit.setTitle("登  录", for: UIControlState.normal)
        btnSubmit.addTarget(self, action: #selector(clickWithLogin), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnSubmit)
        btnSubmit.snp.updateConstraints { (make) in
            make.size.equalTo(rect_submit.size)
            make.centerX.equalTo(self.view)
            make.top.equalTo(origin_y)
        }
        
        btnRegister = UIButton.init(type: UIButtonType.custom)
        btnRegister.backgroundColor = UIColor.clear
        btnRegister.titleLabel?.font = kContentFont
        btnRegister.setTitleColor(Define.kColorBlue(), for: UIControlState.normal)
        btnRegister.setTitle("新用户？去用手机注册", for: UIControlState.normal)
        btnRegister.addTarget(self, action: #selector(clickWithRegister), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnRegister)
        btnRegister.snp.updateConstraints { (make) in
            make.width.equalTo(180)
            make.height.equalTo(40.0)
            make.centerX.equalTo(self.view)
            make.top.equalTo(btnSubmit.snp.bottom).offset(20.0)
        }
        
//        btnAgreement = UIButton.init(type: UIButtonType.custom)
//        btnAgreement.backgroundColor = UIColor.clear
//        btnAgreement.titleLabel?.font = kTitleFont
//        btnAgreement.addTarget(self, action: #selector(clickWithAgreement), for: UIControlEvents.touchUpInside)
//        btnAgreement.setTitle("用户协议", for: UIControlState.normal)
//        btnAgreement.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
//        btnAgreement.setTitleColor(Define.kColorGary(), for: UIControlState.highlighted)
//        self.view.addSubview(btnAgreement)
//        btnAgreement.snp.updateConstraints { (make) in
//            make.size.equalTo(CGSize.init(width: 65.0, height: 30.0))
//            make.bottom.equalTo(self.view).offset(-20.0)
//            make.centerX.equalTo(self.view)
//        }
        
    }
    
    func showIsMessage(msg: String)  {
        Tool.showHUDTip(tipStr: msg)
    }
    
    func clickWithLogin() {
        textNickname.resignFirstResponder()
        textPassword.resignFirstResponder()
        
        let mobileStr: String = (textNickname.text?.stringByTrimingWhitespace())!
        let password: String = (textPassword.text?.stringByTrimingWhitespace())!
        
        if mobileStr.characters.count == 0 {
            showIsMessage(msg: "请输入手机号!")
            return
        }
        
        if password.characters.count == 0 {
            showIsMessage(msg: "请输入验证码!")
            return
        }
        
        if NSString.isValidateMobile(mobileStr) == false {
            showIsMessage(msg: "请输入正确的手机号!")
            return
        }
        
        HttpAPIClient.apiClientPOST("mlogin", params: ["mobile":mobileStr,"code":password], success: { (result) in
            if (result != nil) {
                let json = JSON(result!)
                let data  = json["data"][0]
                if (data["ret"].intValue != 0) {
                    Tool.showHUDTip(tipStr: data["desc"].stringValue)
                    return;
                }
                let info = data["userInfo"]
                UserManager.storeUserWith(json: info)
                let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.setupMainController()
                ChatMessage.shareChat().loginJMessage()
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    func clickWithRegister() {
        let controller: RegisterViewController = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func clickWithAgreement()  {
    
    }
    
    /** 获取验证码 */
    func clickWithCode(sender: PhoneCodeButton) {
        
        let mobileStr: String = textNickname.text!;
        
        if mobileStr.characters.count == 0 {
            showIsMessage(msg: "请输入手机号!")
            return
        }
        
        if NSString.isValidateMobile(mobileStr) == false {
            showIsMessage(msg: "请输入正确的手机号!")
            return
        }
        
        HttpAPIClient.apiClientPOST("sendCode", params: ["mobile":mobileStr], success: { (result) in
            
            self.verify_codeBtn.startUpTimer()
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    
    override func delete(_ sender: Any?) {
        self.verify_codeBtn.invalidateTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.verify_codeBtn.invalidateTimer()
    }
    
    // MARK: -UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str_text: String = textField.text! + string
        
        if textField == textNickname {
            if str_text.characters.count > 11 {
                return false
            }
        } else if textField == textPassword {
            if str_text.characters.count > 6 {
                return false
            }
        }
        
        return true
    }
}
