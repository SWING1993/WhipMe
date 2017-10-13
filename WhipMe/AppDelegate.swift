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
import SwiftyJSON
import HandyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, JPUSHRegisterDelegate, JMessageDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 乐贝壳
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.setupIndexWebController()
//        HttpAPIClient.setupXHLaunchAd()
        HttpAPIClient.startIndexSuccess({ (result) in
            if let dataResult = result {
                let json = JSON(dataResult)
                let struts  = json["iosversion"]["struts"].intValue
                let version  = json["iosversion"]["version"].stringValue
                let myVerison = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                if struts == 1 && myVerison == version {
                    self.setupMainController()
                } else {
                    self.setupIndexWebController()
                }
            }
        }) { (error) in
            self.setupMainController()
        }
        self.thirdPartySDK()
        self.customizeAppearance()
        JPUSHService.setup(withOption: launchOptions, appKey: Define.appKeyJMessage(), channel: Define.channelJMessage(), apsForProduction: true)
        JMessage.setupJMessage(launchOptions, appKey: Define.appKeyJMessage(), channel: Define.channelJMessage(), apsForProduction: false, category: nil)
        JMessage.add(self, with: nil)
        
        window?.backgroundColor = kColorBackGround
        window?.makeKeyAndVisible();
        return true
    }
    
      
    func applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        resetApplicationBadge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0;
        ChatMessage.shareChat().loginJMessage()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JMessage.registerDeviceToken(deviceToken)
//        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //print("Action - didReceiveLocalNotification")
    }
    
    //iOS10 Feature: the front desk agent notified method processing
    @available(iOS 10.0, *)
    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void){
//        let userInfo = notification.request.content.userInfo
//        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler([.sound,.alert])
    }
    
    //iOS10 Feature: proxy method of dealing with the backstage, click on the notification
    @available(iOS 10.0, *)
    private func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void){
//        let userInfo = response.notification.request.content.userInfo
//        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler()
    }
    
    // MARK: - JPUSHRegisterDelegate
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
    }
    
    /** 微信回调 */
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WMShareEngine.sharedInstance().handleOpen(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WMShareEngine.sharedInstance().handleOpen(url)
    }

    // MARK: - Action 方法
    
    func setupIndexWebController() {
        let indexControl: IndexWebController = IndexWebController()
        let indexNav: UINavigationController = UINavigationController.init(rootViewController: indexControl)
        self.window?.rootViewController = indexNav
    }
    
    func setupMainController() {
        if (NSString.isBlankString(UserManager.shared.userId) == false) {
//            let tabControl: MainTabBarController = MainTabBarController()
//            self.window?.rootViewController = tabControl
            let indexControl: IndexViewController = IndexViewController()
            let indexNav: UINavigationController = UINavigationController.init(rootViewController: indexControl)
            self.window?.rootViewController = indexNav
        } else {
            let loginControl: WMLoginWayController = WMLoginWayController()
            let navControl: UINavigationController = UINavigationController.init(rootViewController: loginControl)
            self.window?.rootViewController = navControl
        }
    }
    
    func thirdPartySDK() {
        
        Date.setDefaultRegion(Region.init(tz: TimeZoneName.asiaShanghai.timeZone, cal: CalendarName.gregorian.calendar, loc: LocaleName.chineseChina.locale))

        // ji guang
        JMessage.setLogOFF()
        // wei xin
        WMShareEngine.sharedInstance().registerApp()
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
    
    func resetApplicationBadge() {
//        let badge = UserDefaults.standard.object(forKey: Define.kBADGE())
//        if badge != nil {
//            let number = badge as! Int
//            UIApplication.shared.applicationIconBadgeNumber = number
//            JPUSHService.setBadge(number)
//        }
    }
    
    func onReceive(_ message: JMSGMessage!, error: Error!) {
        NotificationCenter.default.post(name: NSNotification.Name(Define.kUserUnReadCountNotification()), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Define.kAllConversationsNotification()), object: nil)
    }
    
    
    class func removeNotification(myWhipM: WhipM) -> Void {
        let identifier = myWhipM.taskId
        DispatchQueue.global().async {
            if #available(iOS 10.0, *) {
                // 使用 UNUserNotificationCenter 来管理通知
                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: [identifier])
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.cancelAllLocalNotifications()
            }
        }
    }
    
    class func registerNotification(myWhipM: WhipM) -> Void {
        if myWhipM.clockTime.length != 4 {
            return
        }
        let title = "嘿！\"" + myWhipM.themeName + "\"的时间到了耶"
        DispatchQueue.global().async {
            if #available(iOS 10.0, *) {
                let content = UNMutableNotificationContent.init()
                content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
                content.sound = UNNotificationSound.init(named: "小节奏 - 短信铃声.m4r")
                Date.setDefaultRegion(Region.init(tz: TimeZoneName.asiaShanghai.timeZone, cal: CalendarName.gregorian.calendar, loc: LocaleName.chineseChina.locale))
                let minute = (myWhipM.clockTime as NSString).substring(from: 2)
                let hour = (myWhipM.clockTime as NSString).substring(to: 2)
                var components = DateComponents()
                components.hour = Int(hour)
                components.minute = Int(minute)
                components.second = 0
                
                let identifier = myWhipM.taskId
                let trigger = UNCalendarNotificationTrigger.init(dateMatching:components , repeats: true)
                let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                    if (error != nil) {
                        //print("error : \(error)")
                    }
                })
            } else {
                // Fallback on earlier versions
                let notification = UILocalNotification.init()
                let date = NSDate.init(string: myWhipM.clockTime, format: "HHmm")
                notification.fireDate = date as Date?
                notification.timeZone = TimeZoneName.asiaShanghai.timeZone
                notification.repeatInterval = .day
                notification.soundName = "小节奏 - 短信铃声.m4r";
                notification.alertBody = title;
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
    }
}


