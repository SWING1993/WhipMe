//
//  HttpClient.swift
//  WhipMe
//
//  Created by Song on 2016/9/29.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import Alamofire

private let baseURLString = "http://www.superspv.com/json_dispatch.rpc"

typealias CompletionHandler = (Any?, Error?) -> Swift.Void

class HttpClient: NSObject {
    static let sharedInstance = HttpClient()

    public func apiRequest(url: String, parameters: Parameters, method: HTTPMethod, completionHandler: @escaping CompletionHandler) -> Void {
        let requeseurl = baseURLString.appending(url)
        Alamofire.request(requeseurl, method: method, parameters: parameters)
            .responseJSON { response in
                completionHandler(response.result.value,response.result.error)
        }
    }
    
    private func postWithClient(parameters: Parameters, completionHandler: @escaping CompletionHandler) -> Void {
        Alamofire.request(baseURLString, method: .post, parameters: parameters)
            .responseJSON { response in
                completionHandler(response.result.value,response.result.error)
        }
    }
    /**
     1.1 发送短信验证码
     "method":"sendCode",
     "param":{
     "mobile":"手机号"
     }
     */
    public func GetVerificationCode(mobile: String, completionHandler: @escaping CompletionHandler) -> Void {
        let parameters = ["method":"sendCode","param":["mobile":mobile]] as [String : Any]
        
        print("1.1 发送短信验证码: \(parameters)")
        postWithClient(parameters: parameters, completionHandler: completionHandler)
    }
    /**
     1.2 用户登陆
     "method":"login",
     "param":{
     "loginId":"登录ID(手机登录传手机号，微信登录传openId)",
     "code":"手机验证码",
     "loginType":"登录方式(0:手机登陆   1:微信登录)"
     }
     */
    public func loginUser(loginId: String, code: String, loginType: String, completionHandler: @escaping CompletionHandler) -> Void {
        let parameters = ["method":"login", "param":["loginId":loginId,"code":code,"loginType":loginType]] as [String : Any]
        
        print("1.2 用户登陆: \(parameters)")
        postWithClient(parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
     1.3 用户第一次使用微信登录，设置用户昵称
     "method":"addNickname",
     "param":{
     "userId":"21ee4c2266e74f3d812684a3538b20bf",
     "nickname":"用户昵称"
     }
     */
    public func loginWeChat(userId: String, nickname: String, completionHandler: @escaping CompletionHandler) -> Void {
        let parameters = ["method":"addNickname", "param":["userId":userId,"nickname":nickname]] as [String : Any]
        
        print("1.3 用户第一次使用微信登录，设置用户昵称: \(parameters)")
        postWithClient(parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
     1.4 手机注册：第1步
     "method":"validateCode",
     "param":{
     "mobile":"15000000000",
     "code":"123456"
     }
     */
    public func registerMobile(mobile: String, code: String, completionHandler: @escaping CompletionHandler) -> Void {
        let parameters = ["method":"validateCode", "param":["mobile":mobile,"code":code]] as [String : Any]
        
        print("1.4 手机注册：第1步: \(parameters)")
        postWithClient(parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
     1.5 注册：第2步
     "method":"register",
     "param":{
     "mobile":"15000000000",
     "icon":"test.png",
     "nickname":"云淡风轻",
     "sex":"0",
     }
     */
    public func registerUser(mobile: String, icon: String, nickname: String, sex: String, completionHandler: @escaping CompletionHandler) -> Void {
        let parameters = ["method":"register", "param":["mobile":mobile,"icon":icon,"nickname":nickname,"sex":sex]] as [String : Any]
        
        print("1.5 注册：第2步: \(parameters)")
        postWithClient(parameters: parameters, completionHandler: completionHandler)
    }
    
}
