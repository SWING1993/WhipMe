//
//  UITextFiled+MessageInputView.swift
//  WhipMe
//
//  Created by anve on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation

extension String {
    
    func stringByTrimingWhitespace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func numberOfLines() -> Int {
        return self.components(separatedBy: "\n").count+1
    }
    
    
}
