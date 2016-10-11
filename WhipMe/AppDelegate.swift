//
//  AppDelegate.swift
//  WhipMe
//
//  Created by Song on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftDate
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JMessageDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
//        JMessage.add(self, with: nil)
//        JMessage.setupJMessage(launchOptions, appKey: JMESSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
        
        ShareEngine.sharedInstance.registerApp()
        
        registerUserNotification()
        customizeAppearance()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
//        let userName = UserDefaults.standard.object(forKey: Define.kUserName())
//        print("username is \(userName)")
//        if (userName != nil) {
            setupMainController()
//        } else {
//            setupLoginController()
//        }
        window?.backgroundColor = KColorBackGround
        window?.makeKeyAndVisible();
        return true
    }
    
    class func registerNotification(plan: PlanM) -> Void {
        DispatchQueue.global().async {
            if #available(iOS 10.0, *) {
              
                
//                let date = plan.alarmClock
//                print(plan.alarmClock.toTimezone("UTC+8"))

                // 使用 UNUserNotificationCenter 来管理通知
                print(plan.alarmWeeks)

                for (_, value) in plan.alarmWeeks.enumerated() {
                    let center = UNUserNotificationCenter.current()
                    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
                    let content = UNMutableNotificationContent.init()
                    content.title = NSString.localizedUserNotificationString(forKey: "Hello", arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: "Hello,今天星期" + String(value), arguments: nil)
                    content.sound = UNNotificationSound.default()
                    //                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: alertItme, repeats: false)
                    var components = DateComponents.init()
                    components.weekday = value
                    components.hour = 18
                    components.minute = 0
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching:components , repeats: true)
                    let request = UNNotificationRequest.init(identifier: String(value), content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        
                    })
                }
                /*
                let center = UNUserNotificationCenter.current()
                //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
                let content = UNMutableNotificationContent.init()
                content.title = NSString.localizedUserNotificationString(forKey: "Hello", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
                content.sound = UNNotificationSound.default()
//                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: alertItme, repeats: false)
                var components = DateComponents.init()
                components.weekday = 6
                components.hour = 17
                components.minute = 0
                let trigger = UNCalendarNotificationTrigger.init(dateMatching:components , repeats: true)
                
                let request = UNNotificationRequest.init(identifier: "fiveSecond", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in

                })
 */
            } else {
                // Fallback on earlier versions
//                let notification = UILocalNotification.init()
//                let date = Date.init(timeIntervalSinceNow: alertItme)
//                print(Date.init(timeIntervalSinceNow: alertItme))
//                notification.fireDate = date
//                notification.timeZone = NSTimeZone.local
//                notification.repeatInterval = .day
//                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        resetApplicationBadge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("user is \(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("user is 2 \(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("Action - didReceiveLocalNotification")
        JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
    }
    
    /** 微信回调 */
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return ShareEngine.sharedInstance.handleOpenURL(url: url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ShareEngine.sharedInstance.handleOpenURL(url: url)
    }

    // MARK: - Action 方法
    func setupMainController() {
        let tabControl: MainTabBarController = MainTabBarController()
        self.window?.rootViewController = tabControl
    }
    func setupLoginController() {
        let loginControl: LoginWayController = LoginWayController()
        let navControl: UINavigationController = UINavigationController.init(rootViewController: loginControl)
        self.window?.rootViewController = navControl
    }
    
    func customizeAppearance() {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let navigationBarAppearance: UINavigationBar = UINavigationBar.appearance()
        
        navigationBarAppearance.barStyle = UIBarStyle.blackTranslucent
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = Define.kColorNavigation()
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
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName as String:Define.kColorLight()], for: UIControlState.normal)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName as String:UIColor.black], for: UIControlState.selected)
    }
    
    func registerUserNotification() {
        
        //iOS 10 使用以下方法注册，才能得到授权
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            //            center.delegate = self
            center.requestAuthorization(options: [.alert ,.badge ,.sound], completionHandler: { (granted, error) in
                
            })
            center.getNotificationSettings(completionHandler: { (settings) in
                
            })
        } else {
            // Fallback on earlier versions
            
            let types: UIUserNotificationType = [UIUserNotificationType.alert , UIUserNotificationType.badge , UIUserNotificationType.sound]
            JPUSHService.register(forRemoteNotificationTypes:types.rawValue, categories: nil)
        }
    }
    
    func resetApplicationBadge() {
        print("Action - resetApplicationBadge")
        let badge = UserDefaults.standard.object(forKey: Define.kBADGE())
        if badge != nil {
            let number = badge as! Int
            UIApplication.shared.applicationIconBadgeNumber = number
            JPUSHService.setBadge(number)
        }
    }
    
    // MARK:- Notificatioin
    
    func registerJPushStatusNotification() {
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidSetup(notification:)), name: NSNotification.Name.jpfNetworkDidSetup, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(networkIsConnecting(notification:)), name: NSNotification.Name.jpfNetworkIsConnecting, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidClose(notification:)), name: NSNotification.Name.jpfNetworkDidClose, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidRegister(notification:)), name: NSNotification.Name.jpfNetworkDidRegister, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidLogin(notification:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(receivePushMessage(notification:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil);
        
    }
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
    
    // MARK: - JMSGDBMigrateDelegate 数据库升级通知

    func onDBMigrateStart() {
        print("onDBmigrateStart in appdelegate")
    }
    
    func onConversationChanged(_ conversation: JMSGConversation!) {
        
    }
}

@available(iOS 10.0, *)
extension UNUserNotificationCenterDelegate {
    
}

