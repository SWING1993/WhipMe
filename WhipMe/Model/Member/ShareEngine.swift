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
    func sendAuthRequest() {
        
        if WXApi.isWXAppInstalled() == false {
            let alertView = UIAlertView.init(title: "没有安装微信", message: nil, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        let req: SendAuthReq = SendAuthReq.init()
        req.scope = "snsapi_userinfo"
        req.state = "123"
        //第三方向微信终端发送一个SendAuthReq消息结构
        let flag: Bool = WXApi.send(req)
        
        print("send is flag : \(flag)")
    }
    
    // MARK: - WXApi Payment
    func sendWxPaymentId(prePayId: String) {
        
    }

    // MARK: - WxApiDelegate
    func onReq(_ req: BaseReq!) {
        print(req)
    }
    
    func onResp(_ resp: BaseResp!) {
        print(resp)
//        if([resp isKindOfClass:[SendMessageToWXResp class]])
//        {
//            switch (resp.errCode)
//            {
//            case 0:
//                [self sendSuccess];
//                break;
//            case -1:
//                [self sendFail:@"普通错误类型"];
//                break;
//            case -2:
//                [self sendFail:@"用户点击取消并返回"];
//                break;
//            case -3:
//                [self sendFail:@"发送失败"];
//                break;
//            case -4:
//                [self sendFail:@"授权失败"];
//                break;
//            default:
//                [self sendFail:@"微信不支持"];
//                break;
//            }
//        }
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
