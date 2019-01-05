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
    
    fileprivate var myTextView = UITextView.init()
    fileprivate let kWidth = Define.screenWidth()-30
    fileprivate let kHeight = (Define.screenWidth()-30)*0.5
    
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
                    self.okBlock!(self.myTextView.text)
                    self.myTextView.text = nil
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
        myTextView.frame = CGRect.init(x: 10, y: 10, width: kWidth - 20, height: kHeight - 20)
        myTextView.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(myTextView)
        return view
    }
}


extension CommentView:CustomIOSAlertViewDelegate {
    func customIOS7dialogButtonTouchUp(inside alertView: Any!, clickedButtonAt buttonIndex: Int) {
        
    }
}
