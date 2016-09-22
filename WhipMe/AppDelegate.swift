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
    
//        JMessage.add(self, with: nil)
//        JMessage.setupJMessage(launchOptions, appKey: JMESSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
        
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
        window?.backgroundColor = UIColor.white;
        window?.makeKeyAndVisible();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        resetApplicationBadge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("cancelAllLocalNotifications")
        application.cancelAllLocalNotifications()
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

    // MARK: - Action 方法
    func setupMainController() {
        let tabControl: MainTabBarController = MainTabBarController()
        self.window?.rootViewController = tabControl
    }
    func setupLoginController() {
        let loginControl: LoginViewController = LoginViewController()
        let navControl: UINavigationController = UINavigationController.init(rootViewController: loginControl)
        self.window?.rootViewController = navControl
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
    
    func resetApplicationBadge() {
        
        print("Action - resetApplicationBadge")
        
//        let badge: Int = UserDefaults.standard.object(forKey: Define.kBADGE()) as! Int
//        UIApplication.shared.applicationIconBadgeNumber = badge ?? nil
//        JPUSHService.setBadge(badge)
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
    
//    #pragma mark - JMSGMessageDelegate 消息相关的变更通知
//    /*! @abstract 发送消息结果返回回调 */
//    - (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error
//    {
//    DebugLog(@"Action -- onSendMessageResponse %@ , error:%@",message,error);
//    }
//    
//    /*! @abstract 接收消息(服务器端下发的)回调 */
//    - (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error
//    {
//    DebugLog(@"Action -- onReceivemessage %@, error:%@",message,error);
//    DDPostNotification(kDBMigrateFinishNotification);
//    }
//    
//    /*! @abstract 接收消息媒体文件下载失败的回调  */
//    - (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message
//    {
//    DebugLog(@"Action -- onReceiveMessageDownloadFailed %@",message);
//    }
//    
//    #pragma mark - JMSGConversationDelegate 会话相关变更通知
//    /*! @abstract 会话信息变更通知 */
//    - (void)onConversationChanged:(JMSGConversation *)conversation
//    {
//    DebugLog(@"Action -- onConversationChanged");
//    }
//    
//    /*! @abstract 当前剩余的全局未读数 */
//    - (void)onUnreadChanged:(NSUInteger)newCount
//    {
//    DebugLog(@"Action -- onUnreadChanged");
//    }

    
}

