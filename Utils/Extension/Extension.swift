//
//  Extension.swift
//  WhipMe
//
//  Created by Song on 2016/10/11.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation

extension String {
    
    // readonly computed property
    var length: Int {
        return self.utf16.count
    }
    
    func getHeight(font: UIFont, width: CGFloat) -> CGFloat {
        var value: CGFloat = 0.0
        let str: NSString = NSString.init(string: self)
        value += str.getHeightWith(font, constrainedTo: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        return value
    }
    
    func getWidth(font: UIFont, height: CGFloat) -> CGFloat {
        var value: CGFloat = 0.0
        let str: NSString = NSString.init(string: self)
        value += str.getWidthWith(font, constrainedTo: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height))
        return value
    }
}

extension UIImageView {
    func setImageWith(urlString: String, placeholderImage:String) {
        if urlString.isEmpty == false {
            let url = URL.init(string: urlString)!
            self.setImageWith(url, placeholderImage: UIImage.init(named: placeholderImage))
        }
        else {
            if placeholderImage.isEmpty == false {
                self.image = UIImage.init(named: placeholderImage)
            }
        }
    }
}


