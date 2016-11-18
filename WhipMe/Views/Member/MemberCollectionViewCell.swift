//
//  MemberCollectionViewCell.swift
//  WhipMe
//
//  Created by anve on 16/11/17.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation
import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    
    open var imageIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        imageIcon = UIImageView.init()
        imageIcon.backgroundColor = UIColor.gray
        imageIcon.contentMode = UIViewContentMode.scaleAspectFill
        imageIcon.clipsToBounds = true
        self.contentView.addSubview(imageIcon)
        imageIcon.snp.updateConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
}
