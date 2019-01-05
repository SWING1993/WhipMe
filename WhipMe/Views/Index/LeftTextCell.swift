//
//  LeftTextCell.swift
//  WhipMe
//
//  Created by Song on 16/9/23.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class LeftTextCell: NormalCell {

    var cellTitle :UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
   
        self.selectionStyle = .none
        self.backgroundColor = kColorBackGround
        
        
        if cellTitle == nil {
            cellTitle = UILabel.init()
            cellTitle.font = UIFont.systemFont(ofSize: 12)
            cellTitle.baselineAdjustment = .alignCenters
            cellTitle.textAlignment = .left
            self.bgView.addSubview(cellTitle)
            cellTitle.snp.makeConstraints({ (make) in
                make.height.equalTo(self.bgView)
                make.left.equalTo(12)
                make.right.equalTo(-12)
                make.center.equalTo(self.bgView)
            })
        }
        
    }
    
    
    class func cellHeight() -> CGFloat {
        return 58
    }
    
    class func cellReuseIdentifier() -> String {
        return "LeftTextCell"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
