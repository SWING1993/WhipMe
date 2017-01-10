//
//  Define.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Foundation

let kKeyWindows = UIApplication.shared.keyWindow

let kNumFont: UIFont = UIFont.systemFont(ofSize: 10.0)
let kTimeFont: UIFont = UIFont.systemFont(ofSize: 12.0)
let kTitleFont: UIFont = UIFont.systemFont(ofSize: 14.0)
let kContentFont: UIFont = UIFont.systemFont(ofSize: 16.0)
let kButtonFont: UIFont = UIFont.systemFont(ofSize: 18.0)

let kColorWhite: UIColor = UIColor.white
let kColorGolden: UIColor = Define.RGBColorFloat(216.0, g: 198.0, b: 147.0)
let kColorBackGround: UIColor = Define.RGBColorFloat(242.0, g: 242.0, b: 242.0)
let kColorBlack: UIColor = Define.RGBColorFloat(103.0, g: 103.0, b: 103.0)
let kColorGray: UIColor = Define.RGBColorFloat(153.0, g: 153.0, b: 153.0)
let kColorLight: UIColor = Define.RGBColorFloat(182.0, g: 182.0, b: 182.0)
let kColorGary: UIColor = Define.RGBColorFloat(98.0, g: 98.0, b: 98.0)
let kColorBlue: UIColor = Define.RGBColorFloat(71.0, g: 179.0, b: 247.0)
let kColorRed: UIColor = Define.RGBColorFloat(255.0, g: 80.0, b: 80.0)
let kColorNavigation: UIColor = Define.RGBColorFloat(54.0, g: 57.0, b: 62.0)
let kColorLine: UIColor = Define.RGBColorFloat(219.0, g: 219.0, b: 219.0)
let kColorGreen: UIColor = Define.RGBColorFloat(43, g: 200, b: 131)

//fbc12c
let kColorYellow: UIColor = Define.RGBColorFloat(251.0, g:193.0, b:44.0)
//30cb87
let kColorCyanOff: UIColor = Define.RGBColorFloat(48.0, g:203.0, b:135.0)
//25a56c
let kColorCyanOn: UIColor = Define.RGBColorFloat(37.0, g:165.0, b:108.0)


let kNaviHeight: CGFloat = 64.0

let kLeftMargin: CGFloat = 9.0
let kRightMargin: CGFloat = -9.0
let kTopMargin :CGFloat = 4.5
let kBottomMargin :CGFloat = -4.5


let JMESSAGE_APPKEY: String = "e21f0175ea90c6692ca05a39"
let CHANNEL: String = "appstore"

let BUGLY_APPKEY = "0d6f1c4eca"

class Define: NSObject {
    
    class func appIDWeChat() -> String {
        return "wxeb3bed2276716b91"
    }
    
    class func appSecretWeChat() -> String {
        return "33afb229cbad98ef12b0f5bbeb78ee7a"
    }

    class func kDefaultImageHead() -> UIImage {
        return UIImage.init(named: "default_head")!
    }
    
    class func kDefaultPlaceImage() -> UIImage {
        return UIImage.init(named: "nilTouSu")!
    }
    
    // MARK: 颜色的定义
    class func kColorBackGround () -> UIColor {
        return Define.RGBColorFloat(242.0, g: 242.0, b: 242.0)
    }
    
    class func kColorBlack () -> UIColor {
        return Define.RGBColorFloat(103.0, g: 103.0, b: 103.0)
    }
    
    class func kColorGray () -> UIColor {
        return Define.RGBColorFloat(153.0, g: 153.0, b: 153.0)
    }
    
    class func kColorLight () -> UIColor {
        return Define.RGBColorFloat(182.0, g: 182.0, b: 182.0)
    }
    
    class func kColorGary () -> UIColor {
        return Define.RGBColorFloat(98.0, g: 98.0, b: 98.0)
    }
    
    class func kColorBlue () -> UIColor {
        return Define.RGBColorFloat(4.0, g: 162.0, b: 249.0)
    }
    
    class func kColorRed () -> UIColor {
        return Define.RGBColorFloat(255.0, g: 80.0, b: 80.0)
    }
    
    class func kColorNavigation () -> UIColor {
        return Define.RGBColorFloat(54.0, g: 57.0, b: 62.0)
    }
    
    class func kColorLine () -> UIColor {
        return Define.RGBColorFloat(219.0, g: 219.0, b: 219.0)
    }
    //fbc12c
    class func kColorYellow () -> UIColor {
        return Define.RGBColorFloat(251.0, g:193.0, b:44.0)
    }
    //30cb87
    class func kColorCyanOff () -> UIColor {
        return Define.RGBColorFloat(48.0, g:203.0, b:135.0)
    }
    //25a56c
    class func kColorCyanOn () -> UIColor {
        return Define.RGBColorFloat(37.0, g:165.0, b:108.0)
    }
    
    class func kUserName() -> String {
        return "username"
    }
    
    class func kPassword() -> String {
        return "password"
    }
    
    class func kBADGE() -> String {
        return "badge"
    }
    
    // rdg 颜色的定义
    class func RGBColorFloat(_ r: CGFloat, g: CGFloat, b: CGFloat) ->UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class func RGBColorAlphaFloat(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) ->UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    //iPhone的屏幕的物理高度
    class func screenHeight() ->CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //iPhone的屏幕的物理宽度
    class func screenWidth() ->CGFloat {
        return UIScreen.main.bounds.width
    }
    
    //iPhone的屏幕的ScreenBounds
    class func screenBounds() ->CGRect {
        return UIScreen.main.bounds
    }
    
    //iPhone的屏幕的ScreenFrame
//    class func screenFrame() ->CGRect {
//        return UIScreen.main.applicationFrame
//    }
    
    //iPhone的屏幕的ScreenSize
    class func screenSize() ->CGSize {
        return UIScreen.main.bounds.size
    }
    
    //是否为3.5寸的iPhone
    class func isiPhone4x_3_5() ->Bool {
        return UIScreen.main.bounds.height == 480 ? true : false
    }
    
    //是否为4.0寸的iPhone
    class func iphone5x_4_0() ->Bool {
        return UIScreen.main.bounds.height == 568 ? true : false
    }
    
    //是否为4.7寸的iPhone
    class func iphone6_4_7() ->Bool {
        return UIScreen.main.bounds.height == 667 ? true : false
    }
    
    //是否为5.5寸的iPhone
    class func iphone6Plus_5_5() ->Bool {
        return UIScreen.main.bounds.height == 736 ? true : false
    }
}
