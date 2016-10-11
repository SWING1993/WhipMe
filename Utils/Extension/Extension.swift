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
    
}

