//
//  UIView+Size.swift
//  WhipMe
//
//  Created by anve on 16/9/12.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    /// 右边界的x值
    public var right: CGFloat{
        get{
            return self.left + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    /// 下边界的y值
    public var bottom: CGFloat{
        get{
            return self.top + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.left = newValue.x
            self.top = newValue.y
        }
    }
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    public var centerx : CGFloat{
        get{
            return self.width/2.0
        }
        set{
            self.center = CGPoint(x: (self.superview?.frame.size.width)!/2.0, y: self.center.y)
        }
    }
    
    public var centery : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: (self.superview?.frame.size.height)!/2.0)
        }
    }
    
}