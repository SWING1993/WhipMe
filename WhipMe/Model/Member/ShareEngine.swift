//
//  ShareEngine.swift
//  WhipMe
//
//  Created by anve on 16/9/28.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class ShareEngine: NSObject, WXApiDelegate {
    
    static let sharedInstance = ShareEngine()
    
    open var delegate: WXApiEngineDelegate!
    
    func registerApp() {
        WXApi.registerApp(Define.appIDWeChat())
    }
    
    func handleOpenURL(url: URL) -> Bool {
        var flag: Bool = false
        
        print("handle opern url :\(url)")
        if url.absoluteString.hasPrefix("wx") {
            flag = WXApi.handleOpen(url, delegate: self)
        }
        return flag
    }
    
    //构造SendAuthReq结构体
    func sendAuthRequest(aDelegate:WXApiEngineDelegate!) {
        self.delegate = aDelegate
        if WXApi.isWXAppInstalled() == false {
            let alertContorl = UIAlertController.init(title: "没有安装微信", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertContorl.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: { (action) in
                
            }))
            alertContorl.show(self.delegate as! UIViewController, sender: nil)
            return
        }
        
        let req: SendAuthReq = SendAuthReq.init()
        req.scope = "snsapi_userinfo"
        req.state = "whipme"
        //第三方向微信终端发送一个SendAuthReq消息结构
        let flag: Bool = WXApi.send(req)
        
        print("send is flag : \(flag)")
    }
    
    // MARK: - WXApi Payment
    func sendWxPaymentId(prePayId: String) {
        
    }

    // MARK: - WxApiDelegate
    func onReq(_ req: BaseReq!) {
        print("on req is :\(req)")
    }
    
    func onResp(_ resp: BaseResp!) {
        print("on resp is :\(resp)")
        
        if resp.isKind(of: SendAuthResp.classForCoder()) {
            let authResp = resp as! SendAuthResp
            self.delegate.engineDidRecvAuth(response: authResp)
        }
        
        
//        else if ([resp isKindOfClass:[PayResp class]])
//        {
//            if (resp.errCode == WXSuccess)
//            {
//                [self sendSuccess];
//            } else {
//                NSString *strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                [self sendFail:strMsg];
//            }
//        }
    }
}

public protocol WXApiEngineDelegate: NSObjectProtocol {
    
    func engineDidRecvAuth(response: SendAuthResp)
    
    
    
}
