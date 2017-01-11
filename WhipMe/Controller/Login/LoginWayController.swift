//
//  LoginWayController.swift
//  WhipMe
//
//  Created by anve on 16/9/26.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginWayController: UIViewController, WXApiEngineDelegate {

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
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    func setup() {
        
        let imageBG = UIImageView.init(image: UIImage.init(named: "LoginBackground"))
        imageBG.backgroundColor = UIColor.clear
        self.view.addSubview(imageBG)
        imageBG.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        var size_h: CGFloat = 290.0
        if (Define.screenWidth() == 320) {
            size_h = 250.0
        }
        let viewButton = UIView.init()
        viewButton.backgroundColor = UIColor.clear
        self.view.addSubview(viewButton)
        viewButton.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view).offset(-size_h)
            make.top.equalTo(self.view).offset(size_h)
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
            itemButton.titleLabel?.font = kTitleFont
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
        btnAgreement.titleLabel?.font = kTitleFont
        btnAgreement.tag = arrayTitle.count + button_index;
        btnAgreement.addTarget(self, action: #selector(clickWithItem(sender:)), for: UIControlEvents.touchUpInside)
        btnAgreement.setTitle("用户协议", for: UIControlState.normal)
        btnAgreement.setTitleColor(kColorGray, for: UIControlState.normal)
        btnAgreement.setTitleColor(kColorGary, for: UIControlState.highlighted)
        viewButton.addSubview(btnAgreement)
        btnAgreement.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 65.0, height: 30.0))
            make.bottom.equalTo(viewButton).offset(-20.0)
            make.centerX.equalTo(viewButton)
        }
    }
    
    func showIsMessage(msg: String)  {
        let alertControl = UIAlertController.init(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertControl.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func clickWithItem(sender: UIButton) {
        print("\(self.classForCoder) is click \(sender)")
        
        let _index: Int = sender.tag%button_index
        
        if _index == 0 {
            self.navigationController?.pushViewController( LoginViewController(), animated: true)
        } else if _index == 1 {
            WMShareEngine.sharedInstance().sendAuthRequest(self);
           
        } else if _index == 2 {
            self.navigationController?.pushViewController( RegisterViewController(), animated: true)
        } else {
            let controller: WMWebViewController = WMWebViewController.init(webType: .local)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    // MARK: - WXApiEngineDelegate 微信登录
    func shareEngineWXApi(_ response: SendAuthResp!) {
        if response.errCode == -2 {
            //用户取消
        } else if response.errCode == -4 {
            //用户拒绝授权
            
        } else {
            // 0(用户同意)
            HttpAPIClient.apiClientPOST("wlogin", params: ["unionId":response.code], success: { (result) in
                print("wlogin result:\(result)")
                if (result != nil) {
                    let json = JSON(result!)
                    let data = json["data"][0]
                    
                    if (data["ret"].intValue == 1) {
                        print("用户首次登录")
                        
                        let controller = RegisterAndUserController()
                        controller.unionId = response.code
                        self.navigationController?.pushViewController( controller, animated: true)
                        
                    } else if (data["ret"].intValue == 0) {
                        print("用户登录成功")
                        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appdelegate.setupMainController()
                        ChatMessage.shareChat().loginJMessage()
                    } else {
                        Tool.showHUDTip(tipStr: "用户登录失败!")
                    }
                }
            }) { (error) in
                print("wlogin error:\(error)")
            }
        }
    }
}
