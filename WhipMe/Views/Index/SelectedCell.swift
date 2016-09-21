//
//  SelectedCell.swift
//  WhipMe
//
//  Created by Song on 16/9/20.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class SelectedCell: UITableViewCell {

    var selectedImg :UIImageView!
    var cellTitle :UILabel!
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        if selectedImg == nil {
            selectedImg = UIImageView.init()
            self.addSubview(selectedImg)
            selectedImg.snp.makeConstraints({ (make) in
                make.height.width.equalTo(15)
                make.left.equalTo(21)
                make.centerY.equalTo(self)
            })
        }
        
        if self.isSelected {
            selectedImg.image = UIImage.init(named: "choose_btn");
        }else {
            selectedImg.image = UIImage.init(named: "choose_unchecked");
        }
        
        if cellTitle == nil {
            cellTitle = UILabel.init()
            cellTitle.font = UIFont.systemFont(ofSize: 12)
            cellTitle.baselineAdjustment = .alignCenters
            self.addSubview(cellTitle)
            cellTitle.snp.makeConstraints({ (make) in
                make.height.equalTo(20)
                make.width.equalTo(150)
                make.left.equalTo(selectedImg.snp.right).offset(21)
                make.centerY.equalTo(self)
            })
        }
    
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
        if self.isSelected {
            selectedImg.image = UIImage.init(named: "choose_btn");
        }else {
            selectedImg.image = UIImage.init(named: "choose_unchecked");
        }
    }
    
    class func cellHeight() -> CGFloat {
        return 50
    }
    
    class func cellReuseIdentifier() -> String {
        return "SelectedCell"
    }


}
