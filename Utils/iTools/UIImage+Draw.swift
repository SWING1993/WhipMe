//
//  UIView+Draw.swift
//  WhipMe
//
//  Created by anve on 16/9/12.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func imageWithDraw(color: UIColor, sizeMake: CGRect) -> UIImage {
        
        let rect: CGRect = CGRectMake(0, 0, sizeMake.size.width, sizeMake.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
}