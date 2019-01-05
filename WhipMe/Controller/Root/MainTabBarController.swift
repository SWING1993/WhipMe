//
//  MainTabBarController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(clickBadge), name: NSNotification.Name(rawValue: Define.kUserUnReadCountNotification()), object: nil)
        
        let navIndex: UINavigationController = UINavigationController.init(rootViewController: IndexViewController())
        let navFriend: UINavigationController = UINavigationController.init(rootViewController: FriendCircleController())
        let navMember: UINavigationController = UINavigationController.init(rootViewController: WMMemberViewController())
        let chatPageControl: UIPageViewController = UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        let navChat: UINavigationController = WMPrivateChatController.init(rootViewController: chatPageControl)
        
        navIndex.title = "速速花";
        navFriend.title = "发现";
        navChat.title = "消息";
        navMember.title = "我的";
        
        navIndex.tabBarItem.image = UIImage.init(named: "button_we_off")
        navFriend.tabBarItem.image = UIImage.init(named: "button_friend_off")
        navChat.tabBarItem.image = UIImage.init(named: "button_chat_off")
        navMember.tabBarItem.image = UIImage.init(named: "button_my_off")
        
        navIndex.tabBarItem.selectedImage = UIImage.init(named: "button_we_on")
        navFriend.tabBarItem.selectedImage = UIImage.init(named: "button_friend_on")
        navChat.tabBarItem.selectedImage = UIImage.init(named: "button_chat_on")
        navMember.tabBarItem.selectedImage = UIImage.init(named: "button_my_on")
        
        self.viewControllers = [navIndex,navFriend,navChat,navMember];
        self.tabBar.tintColor = UIColor.black
        self.selectedIndex  = 0;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func delete(_ sender: Any?) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func clickBadge() {
        let unCount: Int = JMSGConversation.getAllUnreadCount().intValue
        
        DispatchQueue.main.async {
            if unCount <= 0 {
                self.viewControllers?[2].tabBarItem.badgeValue = nil
            } else if unCount > 99 {
                self.viewControllers?[2].tabBarItem.badgeValue = "99+"
            } else {
                self.viewControllers?[2].tabBarItem.badgeValue = String(unCount)
            }
        }
    }
    
}
