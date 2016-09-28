//
//  UserInfoTableViewCell.swift
//  WhipMe
//
//  Created by anve on 16/9/22.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    var lblTitle: UILabel!
    var lblText: UILabel!
    var imageLogo: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup() {
        
        lblTitle = UILabel.init()
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = Define.kColorBlack()
        lblTitle.font = KContentFont
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.isUserInteractionEnabled = false
        self.contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.left.equalTo(self.contentView).offset(15.0);
            make.right.equalTo(self.contentView).offset(-15.0);
            make.centerY.equalTo(self.contentView)
        }
        
        lblText = UILabel.init()
        lblText.backgroundColor = UIColor.clear
        lblText.textColor = Define.kColorBlack()
        lblText.font = KContentFont
        lblText.textAlignment = NSTextAlignment.right
        lblText.isUserInteractionEnabled = false
        self.contentView.addSubview(lblText)
        lblText.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.left.equalTo(self.contentView).offset(90.0);
            make.right.equalTo(self.contentView).offset(-15.0);
            make.centerY.equalTo(self.contentView)
        }
        
        imageLogo = UIImageView.init()
        imageLogo.backgroundColor = UIColor.clear
        imageLogo.contentMode = UIViewContentMode.scaleToFill
        imageLogo.isUserInteractionEnabled = false
        imageLogo.layer.cornerRadius = 54.0/2.0
        imageLogo.layer.masksToBounds = true
        self.contentView.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 54.0, height: 54.0))
            make.right.equalTo(self.contentView).offset(-15.0)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    class func cellReuseIdentifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
}
