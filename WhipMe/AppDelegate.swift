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
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        JPUSHService.setup(withOption: launchOptions, appKey: Define.appKeyJMessage(), channel: Define.channelJMessage(), apsForProduction: false)
        JMessage.setupJMessage(launchOptions, appKey: Define.appKeyJMessage(), channel: Define.channelJMessage(), apsForProduction: false, category: nil)
        self.registerUserNotification()
        self.thirdPartySDK()
        self.customizeAppearance()
        
        Date.setDefaultRegion(Region.init(tz: TimeZoneName.asiaShanghai.timeZone, cal: CalendarName.gregorian.calendar, loc: LocaleName.chineseChina.locale))
                
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        if (NSString.isBlankString(UserManager.shared.userId) == false) {
            setupMainController()
        } else {
            setupLoginController()
        }
        window?.backgroundColor = kColorBackGround
        window?.makeKeyAndVisible();
        return true
    }
    
   
    func applicationWillResignActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        resetApplicationBadge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
//        ChatMessage.shareChat().loginJMessage()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JMessage.registerDeviceToken(deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("Action - didReceiveLocalNotification")
    }
    
    //iOS10 Feature: the front desk agent notified method processing
    @available(iOS 10.0, *)
    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler([.sound,.alert])
    }
    
    //iOS10 Feature: proxy method of dealing with the backstage, click on the notification
    @available(iOS 10.0, *)
    private func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void){
        let userInfo = response.notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
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
    func setupMainController() {
        let tabControl: MainTabBarController = MainTabBarController()
        self.window?.rootViewController = tabControl
    }
    func setupLoginController() {
        let loginControl: WMLoginWayController = WMLoginWayController()
        let navControl: UINavigationController = UINavigationController.init(rootViewController: loginControl)
        self.window?.rootViewController = navControl
    }
    
    func thirdPartySDK() {
        // ji guang
        JMessage.setLogOFF()
        // wei xin
        WMShareEngine.sharedInstance().registerApp()
        // debug
        let verison_str = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString");
        let config = BuglyConfig()
        config.debugMode = false;
        config.channel = "appStore_V\(verison_str)"
        Bugly.start(withAppId: Define.appKeyBugly(), config: config)
        Bugly.setUserIdentifier(UserManager.shared.mobile)
        
        // 实时修复线上 bug
        JSPatch.start(withAppKey: "b12b0364eb920d55")
        JSPatch.sync()
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
        UIApplication.shared.registerForRemoteNotifications()
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            //            center.delegate = self
            center.requestAuthorization(options: [.alert ,.badge ,.sound], completionHandler: { (granted, error) in
                
            })
            center.getNotificationSettings(completionHandler: { (settings) in
                
            })
        } else {
            let types: UIUserNotificationType = [UIUserNotificationType.alert , UIUserNotificationType.badge , UIUserNotificationType.sound]
            JMessage.register(forRemoteNotificationTypes: types.rawValue, categories: nil)
            
        }
        
        let types_push: JPAuthorizationOptions = [JPAuthorizationOptions.alert, JPAuthorizationOptions.sound, JPAuthorizationOptions.badge]
        let entity = JPUSHRegisterEntity()
        entity.types = Int(types_push.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
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


