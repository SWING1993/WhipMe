//
//  ThirdAddCustomCell Cell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SDWebImage

class ThirdAddCustomCell: NormalCell {
    var addBtn = UIButton()
    var addLabel = UILabel()
    var addTask = AddTaskM()
    
    func setAddTask(task:AddTaskM) {
        self.addTask = task
        if self.addTask.type == "3" {
            addBtn.setImage(UIImage.init(named: "add_superintendent"), for: .normal)
            addLabel.text = "添加监督人"
        }
        
        if self.addTask.type == "2" {
            addBtn.sd_setImage(with: URL.init(string: self.addTask.supervisorIcon), for: .normal, placeholderImage: nil)
            addLabel.text = "监督人:"+self.addTask.supervisorName+"\n自由服务费:"+self.addTask.guarantee+"元"
        }
        
        if self.addTask.type == "1" {
            addBtn.setImage(UIImage.init(named: "system_monitoring"), for: .normal)
            addLabel.text = "监督人:客服监督\n自由服务费:"+self.addTask.guarantee+"元"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Define.kColorBackGround()
        self.selectionStyle = .none
        
        addBtn.layer.masksToBounds = true
        addBtn.layer.shadowRadius = 25.5
        addBtn.setImage(UIImage.init(named: "add_superintendent"), for: .normal)
        bgView.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(51)
            make.centerX.equalTo(bgView)
            make.centerY.equalTo(bgView).offset(-25)

        }
        
        addLabel.text = "添加监督人"
        addLabel.textColor = kColorGary
        addLabel.textAlignment = .center
        addLabel.numberOfLines = 2
        addLabel.font = UIFont.systemFont(ofSize: 14)
        bgView.addSubview(addLabel)
        addLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalTo(bgView)
            make.top.equalTo(addBtn.snp.bottom)
        }
        
        
        let titleLabel = UILabel.init()
        titleLabel.text = "找人监督"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14.5)
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(7.5)
        })
        
        let subTitleL = UILabel.init()
        subTitleL.text = "功能介绍：可以找系统或好友监督，交一定的自由服务费，达成后退还，达不成，自由服务费归监督人所有。"
        subTitleL.numberOfLines = 2
        subTitleL.textColor = kColorGary
        subTitleL.font = UIFont.systemFont(ofSize: 10)
        bgView.addSubview(subTitleL)
        subTitleL.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.left.equalTo(15)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        })
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
    
    class func cellHeight() -> CGFloat {
        return 176
    }
    
    class func cellReuseIdentifier() -> String {
        return "ThirdAddCustomCell"
    }

}
