//
//  UIView+Draw.swift
//  WhipMe
//
//  Created by anve on 16/9/12.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func imageWithDraw(_ color: UIColor, sizeMake: CGRect) -> UIImage {
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: sizeMake.size.width, height: sizeMake.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    
    
}
