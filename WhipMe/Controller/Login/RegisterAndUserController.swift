//
//  RegisterAndUserController.swift
//  WhipMe
//
//  Created by anve on 16/9/27.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class RegisterAndUserController: UIViewController {

    var nickname: String!
    var password: String!
    var uesrSex: String!
    var avatar: String!
    var userName: String!
    
    var btnAvatar: UIButton!
    var txtNickname: UITextField!
    var btnSubmit: UIButton!
    var btnAgreement: UIButton!
    var arrayButtonSex: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "创建账号"
        self.view.backgroundColor = Define.kColorBackGround()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        btnAvatar = UIButton.init(type: UIButtonType.custom)
        btnAvatar.backgroundColor = UIColor.clear
        btnAvatar.layer.cornerRadius = 31.0
        btnAvatar.layer.masksToBounds = true
        btnAvatar.setImage(UIImage.init(named: "button_addHeader_off"), for: UIControlState.normal)
        btnAvatar.setImage(UIImage.init(named: "button_addHeader_on"), for: UIControlState.highlighted)
        btnAvatar.addTarget(self, action: #selector(clickWithAvatar), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnAvatar)
        btnAvatar.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 62.0, height: 62.0))
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(45.0)
        }
        
        let lblAvatar = UILabel.init()
        lblAvatar.backgroundColor = UIColor.clear
        lblAvatar.textAlignment = NSTextAlignment.center
        lblAvatar.textColor = Define.kColorBlack()
        lblAvatar.font = KTitleFont
        lblAvatar.text = "添加头像"
        self.view.addSubview(lblAvatar)
        lblAvatar.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100.0, height: 16.0))
            make.centerX.equalTo(self.view)
            make.top.equalTo(btnAvatar.snp.bottom).offset(10.0)
        }
        
        txtNickname = UITextField.init()
        txtNickname.backgroundColor = UIColor.white
        txtNickname.font = KContentFont
        txtNickname.textAlignment = NSTextAlignment.left
        txtNickname.textColor = Define.kColorBlack()
        txtNickname.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        txtNickname.placeholder = "输入昵称"
        txtNickname.layer.cornerRadius = 4.0
        txtNickname.layer.masksToBounds = true
        self.view.addSubview(txtNickname)
        
        let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10.0, height: 0))
        viewLeft.backgroundColor = UIColor.clear
        txtNickname.leftView = viewLeft
        txtNickname.leftViewMode = UITextFieldViewMode.always
        txtNickname.snp.updateConstraints({ (make) in
            make.width.equalTo(Define.screenWidth() - 36.0)
            make.height.equalTo(44.0)
            make.centerX.equalTo(self.view)
            make.top.equalTo(lblAvatar.snp.bottom).offset(12.0)
        })
        
        let arraySex: Array = ["男","女"]
        arrayButtonSex = NSMutableArray.init(capacity: 0)
        var origin_x: CGFloat = 18.0
        for sex in arraySex {
            let itemButton = UIButton.init(type: UIButtonType.custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.setImage(UIImage.init(named: "button_choose_off"), for: UIControlState.normal)
            itemButton.setImage(UIImage.init(named: "button_choose_on"), for: UIControlState.selected)
            itemButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 0, right: 0)
            itemButton.setTitle(sex, for: UIControlState.normal)
            itemButton.titleLabel?.font = KTitleFont
            itemButton.adjustsImageWhenHighlighted = false
            itemButton.setTitleColor(Define.kColorBlack(), for: UIControlState.normal)
            itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            itemButton.addTarget(self, action: #selector(clickWithSex(sender:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(itemButton)
            arrayButtonSex.add(itemButton)
            itemButton.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 84.0, height: 40.0))
                make.left.equalTo(self.view).offset(origin_x)
                make.top.equalTo(txtNickname.snp.bottom).offset(10.0)
            })
            
            origin_x += 84.0
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
            make.top.equalTo(txtNickname.snp.bottom).offset(110.0)
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
    
    func clickWithAvatar() {
        
    }
    
    func clickWithSex(sender: UIButton)  {
        for itemButton in arrayButtonSex {
            let button = itemButton as! UIButton;
            if button == sender {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    func clickWithRegister() {
        
    }
    
    func clickWithAgreement() {
        
    }
    
}
