//
//  Define.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import Foundation

let KNumFont: UIFont = UIFont.systemFontOfSize(10.0)
let KTimeFont: UIFont = UIFont.systemFontOfSize(12.0)
let KTitleFont: UIFont = UIFont.systemFontOfSize(14.0)
let KContentFont: UIFont = UIFont.systemFontOfSize(16.0)
let KButtonFont: UIFont = UIFont.systemFontOfSize(18.0)

let KColorBackGround: UIColor = Define.RGBColorFloat(242.0, g: 242.0, b: 242.0)
let KColorBlack: UIColor = Define.RGBColorFloat(47.0, g: 49.0, b: 61.0)
let KColorLight: UIColor = Define.RGBColorFloat(130.0, g: 131.0, b: 138.0)
let KColorGary: UIColor = Define.RGBColorFloat(98.0, g: 98.0, b: 98.0)
let KColorRed: UIColor = Define.RGBColorFloat(255.0, g: 80.0, b: 80.0)
let KColorNavigation: UIColor = Define.RGBColorFloat(33.0, g: 32.0, b: 37.0)


class Define: NSObject {
    
    class func RGBColorFloat(r: CGFloat, g: CGFloat, b: CGFloat) ->UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class func RGBColorAlphaFloat(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) ->UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    //iPhone的屏幕的物理高度
    class func screenHeight() ->CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    //iPhone的屏幕的物理宽度
    class func screenWidth() ->CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    //iPhone的屏幕的ScreenBounds
    class func screenBounds() ->CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    //iPhone的屏幕的ScreenFrame
    class func screenFrame() ->CGRect {
        return UIScreen.mainScreen().applicationFrame
    }
    
    //iPhone的屏幕的ScreenSize
    class func screenSize() ->CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    //是否为3.5寸的iPhone
    class func isiPhone4x_3_5() ->Bool {
        return UIScreen.mainScreen().bounds.height == 480 ? true : false
    }
    
    //是否为4.0寸的iPhone
    class func iphone5x_4_0() ->Bool {
        return UIScreen.mainScreen().bounds.height == 568 ? true : false
    }
    
    //是否为4.7寸的iPhone
    class func iphone6_4_7() ->Bool {
        return UIScreen.mainScreen().bounds.height == 667 ? true : false
    }
    
    //是否为5.5寸的iPhone
    class func iphone6Plus_5_5() ->Bool {
        return UIScreen.mainScreen().bounds.height == 736 ? true : false
    }
    
    
}