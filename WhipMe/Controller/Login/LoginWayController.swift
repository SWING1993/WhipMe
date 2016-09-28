//
//  LoginWayController.swift
//  WhipMe
//
//  Created by anve on 16/9/26.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class LoginWayController: UIViewController {

    private let button_index: Int = 7777
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setup() {
        
        let imageBG = UIImageView.init(image: UIImage.init(named: "LoginBackground"))
        imageBG.backgroundColor = UIColor.clear
        self.view.addSubview(imageBG)
        imageBG.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let viewButton = UIView.init()
        viewButton.backgroundColor = UIColor.clear
        self.view.addSubview(viewButton)
        viewButton.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view).offset(-290.0)
            make.top.equalTo(self.view).offset(290.0)
        }
        
        let arrayImageOff: Array = ["button_phone_off","button_weixin_off","button_create_off"]
        let arrayImageOn: Array  = ["button_phone_on","button_weixin_on","button_create_on"]
        let arrayTitle: Array = ["手机登录","微信登录","创建账号"]
        var origin_y: CGFloat = 0.0
        
        for i in 0..<arrayTitle.count {
            
            let strTitle: String = arrayTitle[i]
            let strImageOff: String = arrayImageOff[i]
            let strImageOn: String = arrayImageOn[i]
            
            let itemButton: UIButton = UIButton.init(type: UIButtonType.custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel?.font = KTitleFont
            itemButton.titleEdgeInsets = UIEdgeInsets.init(top: 55.0, left: -45.0, bottom: 0, right: 0)
            itemButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 20.0, right: 0)
            itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            itemButton.contentVerticalAlignment = UIControlContentVerticalAlignment.top
            itemButton.setImage(UIImage.init(named: strImageOff), for: UIControlState.normal)
            itemButton.setImage(UIImage.init(named: strImageOn), for: UIControlState.highlighted)
            itemButton.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
            itemButton.setTitleColor(Define.kColorGary(), for: UIControlState.highlighted)
            itemButton.setTitle(strTitle, for: UIControlState.normal)
            itemButton.tag = i+button_index;
            itemButton.addTarget(self, action: #selector(clickWithItem(sender:)), for: UIControlEvents.touchUpInside)
            viewButton.addSubview(itemButton)
            itemButton.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 65.0, height: 65.0))
                make.top.equalTo(origin_y)
                make.centerX.equalTo(viewButton)
            })
            
            origin_y += 93.0
        }
        
        let btnAgreement = UIButton.init(type: UIButtonType.custom)
        btnAgreement.backgroundColor = UIColor.clear
        btnAgreement.titleLabel?.font = KTitleFont
        btnAgreement.tag = arrayTitle.count + button_index;
        btnAgreement.addTarget(self, action: #selector(clickWithItem(sender:)), for: UIControlEvents.touchUpInside)
        btnAgreement.setTitle("用户协议", for: UIControlState.normal)
        btnAgreement.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
        btnAgreement.setTitleColor(Define.kColorGary(), for: UIControlState.highlighted)
        viewButton.addSubview(btnAgreement)
        btnAgreement.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 65.0, height: 30.0))
            make.bottom.equalTo(viewButton).offset(-20.0)
            make.centerX.equalTo(viewButton)
        }
    }

    func clickWithItem(sender: UIButton) {
        print("\(self.classForCoder) is click \(sender)")
        
        let _index: Int = sender.tag%button_index
        
        if _index == 0 {
            self.navigationController?.pushViewController( LoginViewController(), animated: true)
        } else if _index == 1 {
            print("微信登录 is click")
        } else if _index == 2 {
            self.navigationController?.pushViewController( RegisterViewController(), animated: true)
        } else {
            print("用户协议 is click")
        }
        
    }
    
}
