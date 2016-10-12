//
//  SGHDateView.swift
//  WhipMe
//
//  Created by Song on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftDate
class SGHDateView: NSObject {
    
    static let sharedInstance = SGHDateView()
    
    var okBlock : ((Date) -> Void)?
    var cancelBlock : (() -> Void)?
    var pickerMode : UIDatePickerMode?
    
    fileprivate let picker = UIDatePicker.init()
    fileprivate let kWidth = Define.screenWidth()-30
    fileprivate let kHeight = (Define.screenWidth()-30)*0.7
    
    func show() {
        self.picker.datePickerMode = pickerMode!
        let alertView = CustomIOSAlertView.init()
        alertView?.containerView = contentView()
        alertView?.buttonTitles = ["取消","确定"]
        alertView?.delegate = self
        
        alertView?.onButtonTouchUpInside = { alertView, buttonIndex in
            print(buttonIndex)
            if buttonIndex == 1 {
                if self.okBlock != nil {
                    let date = self.picker.date
                    self.okBlock!(date)
                }
            }
            else {
                if self.cancelBlock != nil {
                    self.cancelBlock!()
                }
            }
            alertView?.close()
        }
        
        alertView?.useMotionEffects = true
        alertView?.show()
    }
    
    
    fileprivate func contentView() -> UIView {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        picker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        picker.frame = CGRect.init(x: 10, y: 10, width: kWidth - 20, height: kHeight - 20)
        view.addSubview(picker)
        return view
    }

}


extension SGHDateView:CustomIOSAlertViewDelegate {
    func customIOS7dialogButtonTouchUp(inside alertView: Any!, clickedButtonAt buttonIndex: Int) {
        
    }
}
