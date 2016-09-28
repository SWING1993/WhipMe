//
//  RegisterViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    var textNickname: UITextField!
    var textPassword: UITextField!
    var btnSubmit: UIButton!
    var btnAgreement: UIButton!
    var verify_codeBtn: PhoneCodeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "创建账号"
        view.backgroundColor = Define.kColorBackGround()
        
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
            itemText.font = KContentFont
            itemText.textAlignment = NSTextAlignment.left
            itemText.textColor = Define.kColorBlack()
            itemText.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            itemText.placeholder = itemStr as? String
            itemText.layer.cornerRadius = 4.0
            itemText.layer.masksToBounds = true
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
                textPassword.isSecureTextEntry = true
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
                verify_codeBtn.titleLabel?.font = KTitleFont
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
        btnSubmit.titleLabel?.font = KButtonFont
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnSubmit.layer.cornerRadius = 4.0
        btnSubmit.layer.masksToBounds = true
        btnSubmit.setTitle("创  建", for: UIControlState.normal)
        btnSubmit.addTarget(self, action: #selector(clickWithRegister), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnSubmit)
        btnSubmit.snp.updateConstraints { (make) in
            make.size.equalTo(rect_submit.size)
            make.centerX.equalTo(self.view)
            make.top.equalTo(origin_y)
        }
        
        btnAgreement = UIButton.init(type: UIButtonType.custom)
        btnAgreement.backgroundColor = UIColor.clear
        btnAgreement.titleLabel?.font = KTitleFont
        btnAgreement.addTarget(self, action: #selector(clickWithAgreement), for: UIControlEvents.touchUpInside)
        btnAgreement.setTitle("用户协议", for: UIControlState.normal)
        btnAgreement.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
        btnAgreement.setTitleColor(Define.kColorGary(), for: UIControlState.highlighted)
        self.view.addSubview(btnAgreement)
        btnAgreement.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 65.0, height: 30.0))
            make.bottom.equalTo(self.view).offset(-20.0)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    func clickWithRegister() {
        print(self.classForCoder)
        
        textNickname.resignFirstResponder()
        textPassword.resignFirstResponder()
        
        let nickname: String = (textNickname.text?.stringByTrimingWhitespace())!
        let password: String = (textPassword.text?.stringByTrimingWhitespace())!
        
        print("nickname is \(nickname)")
        print("password is \(password)")
        
//        if checkValid(username: nickname, password: password) {
//            
//            JMSGUser.register(withUsername: nickname, password: password, completionHandler: { (result, error) in
//                if (error == nil) {
//                    JMSGUser .login(withUsername: nickname, password: password, completionHandler: { (loginResult, LoginError) in
//                        if (error == nil) {
//                            let user: UserDefaults = UserDefaults.standard
//                            user.set(nickname, forKey: Define.kUserName())
//                            user.set(password, forKey: Define.kPassword())
//                            user.synchronize()
//                            
//                            let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appdelegate.setupMainController()
//                        } else {
//                            print("login is fail")
//                        }
//                    })
//                } else {
//                    print("注册失败")
//                }
//            })
//        }
        
        let controller = RegisterAndUserController()
        controller.userName = nickname
        controller.password = password
        self.navigationController?.pushViewController( controller, animated: true)
    }
    
    func clickWithAgreement()  {
        
    }
    
    func clickWithCode(sender: PhoneCodeButton) {
        
        if self.verify_codeBtn.isSelected {
            self.verify_codeBtn.isSelected = false
            self.verify_codeBtn.invalidateTimer()
        } else {
            self.verify_codeBtn.isSelected = true
            self.verify_codeBtn.startUpTimer()
        }
    }
    
    func checkValid(username: String, password: String) -> Bool {
        if username.characters.count > 0 && password.characters.count > 0 {
            return true
        }
        
        var alert: String = "用户名或者密码不合法."
        if username == "" {
            alert = "用户名不能为空"
        } else if password == "" {
            alert = "密码不能为空"
        }
        
        print("login error is \(alert)")
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }

}
