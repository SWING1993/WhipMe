//
//  Tool.swift
//  WhipMe
//
//  Created by Song on 2016/10/10.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import Foundation

class Tool: NSObject {
    
    class func showHUDTip(tipStr: String) {
        let hud = MBProgressHUD.showAdded(to: kKeyWindows!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = tipStr
        hud.label.font = UIFont.systemFont(ofSize: 15.0)
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
    }
}
