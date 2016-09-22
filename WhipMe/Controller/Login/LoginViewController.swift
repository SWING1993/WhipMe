//
//  LoginViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var textNickname: UITextField!
    var textPassword: UITextField!
    var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "极光IM"
        view.backgroundColor = KColorBackGround
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        let texts: NSArray = ["用户名","密码"]
        var origin_y: CGFloat = 20.0
        for itemStr in texts {
            let itemText: UITextField = UITextField.init()
            itemText.backgroundColor = UIColor.white
            itemText.font = KContentFont
            itemText.textAlignment = NSTextAlignment.left
            itemText.textColor = KColorBlack
            itemText.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            itemText.placeholder = itemStr as? String
            itemText.layer.cornerRadius = 4.0
            itemText.layer.masksToBounds = true
            view.addSubview(itemText)
            itemText.snp.updateConstraints({ (make) in
                make.width.equalTo(Define.screenWidth() - 40.0)
                make.height.equalTo(44.0)
                make.centerX.equalTo(view)
                make.top.equalTo(origin_y)
            })
            
            let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10.0, height: 0))
            viewLeft.backgroundColor = UIColor.clear
            itemText.leftView = viewLeft
            itemText.leftViewMode = UITextFieldViewMode.always
            
            if itemStr as? String == "用户名" {
                textNickname = itemText
            } else {
                textPassword = itemText
            }
            
            origin_y += 64.0
        }
        
        btnSubmit = UIButton.init(type: UIButtonType.custom)
        btnSubmit.backgroundColor = KColorBlue
        btnSubmit.titleLabel?.font = KButtonFont
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnSubmit.setTitle("登录", for: UIControlState.normal)
        btnSubmit.addTarget(self, action: #selector(clickWithLogin), for: UIControlEvents.touchUpInside)
        view.addSubview(btnSubmit)
        btnSubmit.snp.updateConstraints { (make) in
            make.width.equalTo(Define.screenWidth() - 40.0)
            make.height.equalTo(44.0)
            make.centerX.equalTo(view)
            make.top.equalTo(origin_y)
        }
        
        let btnRegister: UIButton = UIButton.init(type: UIButtonType.custom)
        btnRegister.backgroundColor = UIColor.clear
        btnRegister.titleLabel?.font = KContentFont
        btnRegister.setTitleColor(KColorBlue, for: UIControlState.normal)
        btnRegister.setTitle("注册", for: UIControlState.normal)
        btnRegister.addTarget(self, action: #selector(clickWithRegister), for: UIControlEvents.touchUpInside)
        view.addSubview(btnRegister)
        btnRegister.snp.updateConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(40.0)
            make.right.equalTo(btnSubmit.snp.right)
            make.top.equalTo(btnSubmit.snp.bottom)
        }
    }
    
    func clickWithLogin() {
        print(self.classForCoder)
        
        textNickname.resignFirstResponder()
        textPassword.resignFirstResponder()
        
        let nickname: String = (textNickname.text?.stringByTrimingWhitespace())!
        let password: String = (textPassword.text?.stringByTrimingWhitespace())!
        
        print("nickname is \(nickname)")
        print("password is \(password)")
        
        if checkValid(username: nickname, password: password) {
            
            JMSGUser.login(withUsername: nickname, password: password, completionHandler: { (result, error) in
                if (error == nil) {
                    let user: UserDefaults = UserDefaults.standard
                    user.set(nickname, forKey: Define.kUserName())
                    user.set(password, forKey: Define.kPassword())
                    user.synchronize()
                    
                    let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.setupMainController()
                } else {
                    print("login is fail")
                }
            })
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
    
    func clickWithRegister() {
        let controller: RegisterViewController = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}
