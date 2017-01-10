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
        let navIndex: UINavigationController = UINavigationController.init(rootViewController: IndexViewController())
        let navFriend: UINavigationController = UINavigationController.init(rootViewController: FriendCircleController())
        let navChat: UINavigationController = UINavigationController.init(rootViewController: PrivateChatController())
        let navMember: UINavigationController = UINavigationController.init(rootViewController: WMMemberViewController())
        
        navIndex.title = "主页";
        navFriend.title = "朋友圈";
        navChat.title = "私聊";
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
