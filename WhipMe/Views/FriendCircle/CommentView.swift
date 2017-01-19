//
//  CommentView.swift
//  WhipMe
//
//  Created by Song on 2017/1/19.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit

class CommentView: NSObject {

    static let sharedInstance = CommentView()
    
    var okBlock : ((String) -> Void)?
    var cancelBlock : (() -> Void)?
    
    fileprivate let myTextView = UITextView.init()
    fileprivate let kWidth = Define.screenWidth()-30
    fileprivate let kHeight = (Define.screenWidth()-30)*0.7
    
    func show() {
        let alertView = CustomIOSAlertView.init()
        alertView?.containerView = contentView()
        alertView?.buttonTitles = ["取消","确定"]
        alertView?.delegate = self
        alertView?.useMotionEffects = true
        alertView?.show()
        self.myTextView.becomeFirstResponder()
        
        alertView?.onButtonTouchUpInside = { alertView, buttonIndex in
            if buttonIndex == 1 {
                if self.okBlock != nil {
                    self.myTextView.text = nil
                    self.okBlock!(self.myTextView.text)
                }
            } else {
                if self.cancelBlock != nil {
                    self.cancelBlock!()
                }
            }
            alertView?.close()
        }
    }
    
    fileprivate func contentView() -> UIView {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        myTextView = CGRect.init(x: 10, y: 10, width: kWidth - 20, height: kHeight - 20)
        view.addSubview(picker)
        return view
    }
}


extension CommentView:CustomIOSAlertViewDelegate {
    func customIOS7dialogButtonTouchUp(inside alertView: Any!, clickedButtonAt buttonIndex: Int) {
        
    }
}
