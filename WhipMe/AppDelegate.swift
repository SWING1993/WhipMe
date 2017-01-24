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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        //ji guang
        JMessage.setupJMessage(launchOptions, appKey: Define.appKeyJMessage(), channel: Define.channelJMessage(), apsForProduction: false, category: nil)
        JMessage.setLogOFF()
        // wei xin
        WMShareEngine.sharedInstance().registerApp()
        // debug
        let verison_str = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString");
        let config = BuglyConfig()
        config.debugMode = false;
        config.channel = "appStore_V\(verison_str)"
        Bugly.start(withAppId: Define.appKeyBugly(), config: config)
        registerUserNotification()
        customizeAppearance()
        
        Date.setDefaultRegion(Region.init(tz: TimeZoneName.asiaShanghai.timeZone, cal: CalendarName.gregorian.calendar, loc: LocaleName.chineseChina.locale))
        
//        PLeakSniffer.sharedInstance.installLeakSniffer
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
//        let loginControl: WMAboutViewController = WMAboutViewController()
//        let navControl: UINavigationController = UINavigationController.init(rootViewController: loginControl)
//        self.window?.rootViewController = navControl

        
        if (NSString.isBlankString(UserManager.shared.userId) == false) {
            setupMainController()
        } else {
            setupLoginController()
        }
        window?.backgroundColor = kColorBackGround
        window?.makeKeyAndVisible();
        return true
    }
    
    class func removeNotification(plan: PlanM) -> Void {
        DispatchQueue.global().async {
            if plan.alarmWeeks.count <= 0 {
                return
            }
            if #available(iOS 10.0, *) {
                // 使用 UNUserNotificationCenter 来管理通知
    
                let identifiers =  plan.alarmWeeks.map({ (value) -> String in
                    let indentifier = plan.themeName + String(value)
                    return indentifier
                })
                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: identifiers)
                center.removePendingNotificationRequests(withIdentifiers: identifiers)
                print("删除通知：\(identifiers)")

            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    class func registerNotification(plan: PlanM) -> Void {
        DispatchQueue.global().async {
            /*
            if #available(iOS 10.0, *) {
                // 使用 UNUserNotificationCenter 来管理通知
                for (_, value) in plan.alarmWeeks.enumerated() {
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent.init()
                    content.title = NSString.localizedUserNotificationString(forKey: plan.themeName, arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: plan.plan, arguments: nil)
                    content.sound = UNNotificationSound.default()
                    var components = DateComponents.init()
                    components.weekday = value
                    components.hour = plan.alarmClock.hour
                    components.minute = plan.alarmClock.minute
                    components.second = 0
                    let identifier = plan.themeName + String(value)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching:components , repeats: true)
                    let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        print("error : \(error)")
                    })
                    let string = String(plan.alarmClock.hour) + ":" + String(plan.alarmClock.minute)
                    print("成功添加" + identifier + "的" + string + "本地通知")
                }
            } else {
                // Fallback on earlier versions
                let notification = UILocalNotification.init()
                let date = Date.init(timeIntervalSinceNow: alertItme)
                print(Date.init(timeIntervalSinceNow: alertItme))
                notification.fireDate = date
                notification.timeZone = NSTimeZone.local
                notification.repeatInterval = .day
                UIApplication.shared.scheduleLocalNotification(notification)
            }
            */
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
        ChatMessage.shareChat().loginJMessage()
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
        return WMShareEngine.sharedInstance().handleOpen(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WMShareEngine.sharedInstance().handleOpen(url)
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
        navigationBarAppearance.titleTextAttributes =  [kCTFontAttributeName as String:kButtonFont, kCTForegroundColorAttributeName as String:UIColor.white]
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.shadowImage = UIImage.init()
        
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
            let types: UIUserNotificationType = [UIUserNotificationType.alert , UIUserNotificationType.badge , UIUserNotificationType.sound]
            JPUSHService.register(forRemoteNotificationTypes:types.rawValue, categories: nil)
        }
    }
    
    func resetApplicationBadge() {
//        let badge = UserDefaults.standard.object(forKey: Define.kBADGE())
//        if badge != nil {
//            let number = badge as! Int
//            UIApplication.shared.applicationIconBadgeNumber = number
//            JPUSHService.setBadge(number)
//        }
    }
}

@available(iOS 10.0, *)
extension UNUserNotificationCenterDelegate {
    
}

