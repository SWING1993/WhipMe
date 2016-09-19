//
//  AppDelegate.swift
//  WhipMe
//
//  Created by Song on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JMessageDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        
        /// Required - 添加 JMessage SDK 监听。这个动作放在启动前
        JMessage.add(self, with: JMSGConversation.init())
        /// Required - 启动 JMessage SDK
        JMessage.setupJMessage(launchOptions, appKey: JMESSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
        
        
        customizeAppearance()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
    
        window?.rootViewController = MainTabBarController();
        
        window?.backgroundColor = UIColor.white;
        window?.makeKeyAndVisible();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    func customizeAppearance() {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let navigationBarAppearance: UINavigationBar = UINavigationBar.appearance()
        
        navigationBarAppearance.barStyle = UIBarStyle.blackTranslucent
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = KColorNavigation
        navigationBarAppearance.titleTextAttributes =  [kCTFontAttributeName as String:KButtonFont, kCTForegroundColorAttributeName as String:UIColor.white]
        navigationBarAppearance.tintColor = UIColor.white
        
        let barButtonAppearance: UIBarButtonItem = UIBarButtonItem.appearance()
        barButtonAppearance.tintColor = UIColor.white
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60.0), for: UIBarMetrics.default)
        
        //去除 TabBar 自带的顶部阴影
        let tabBarAppearance: UITabBar = UITabBar.appearance()
        tabBarAppearance.shadowImage = UIImage.init()
        tabBarAppearance.tintColor = UIColor.black
        
        let tabBarItem: UITabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName as String:KColorLight], for: UIControlState.normal)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName as String:UIColor.black], for: UIControlState.selected)
    }
    
    func registerUserNotification() {
        
        let types: UIUserNotificationType = [UIUserNotificationType.alert , UIUserNotificationType.badge , UIUserNotificationType.sound]
        JPUSHService.register(forRemoteNotificationTypes:types.rawValue, categories: nil)
    }

    func registerJPushStatusNotification() {
        
    }
    
    // MARK:- Notificatioin
    
    /** 建立连接 */
    func networkDidSetup(notification: NSNotification) {
        print("建立连接")
    }
    
    /** 正在连接中 */
    func networkIsConnecting(notification: NSNotification) {
        print("正在连接中...")
    }
    
    /** 关闭连接 */
    func networkDidClose(notification: NSNotification) {
        print("正在连接中...")
    }
    
    /** 注册成功 */
    func networkDidRegister(notification: NSNotification) {
        print("注册成功")
    }
    
    /** 登录成功 */
    func networkDidLogin(notification: NSNotification) {
        print("登录成功")
    }
    
    /** 收到消息 */
    func receivePushMessage(notification: NSNotification) {
        print("收到消息")
        
        let info = notification.userInfo as! [String: AnyObject]
        
        print("The message -"+info.description)
        
    }
    
}

