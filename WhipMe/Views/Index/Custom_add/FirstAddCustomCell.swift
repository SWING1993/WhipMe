//
//  FirstAddCustomCell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstAddCustomCell: NormalCell {
    var titleT : UITextField!
    var contentT : UIPlaceHolderTextView!
    var disposeBag = DisposeBag()
    var titleChangedBlock : ((String) -> Void)?
    var contentChangedBlock : ((String) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Define.kColorBackGround()
        self.selectionStyle = .none
        
        if titleT == nil {
            titleT = UITextField.init()
            titleT.textColor = Define.kColorBlack()
            titleT.font = UIFont.systemFont(ofSize: 14.5)
            titleT.placeholder = "请输入名称"
            self.bgView.addSubview(titleT)
            titleT.snp.makeConstraints({ (make) in
                make.height.equalTo(45)
                make.left.equalTo(21)
                make.right.equalTo(-21)
                make.top.equalTo(5)
            })
        }
        
        let line = UIView.init()
        line.backgroundColor = kColorLine
        self.bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(titleT.snp.bottom)
            make.height.equalTo(0.5)
        }

        
        if contentT == nil {
            contentT = UIPlaceHolderTextView.init()
            contentT.font = UIFont.systemFont(ofSize: 14)
            contentT.placeholder = "请详细描述您的计划"
            self.bgView.addSubview(contentT)
            contentT.snp.makeConstraints({ (make) in
                make.height.equalTo(155)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(titleT.snp.bottom).offset(1)
            })
        }
    
        let titleChange = titleT.rx.text
        titleChange.bindNext({ (value) in
                if self.titleChangedBlock != nil {
                    self.titleChangedBlock!(value!)
                }
            })
            .addDisposableTo(disposeBag)
        
        
        let contentChange = contentT.rx.text
        contentChange.bindNext({ (value) in
                if self.contentChangedBlock != nil {
                    self.contentChangedBlock!(value!)
                }
            })
            .addDisposableTo(disposeBag)
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
        return 210
    }
    
    class func cellReuseIdentifier() -> String {
        return "FirstAddCustomCell"
    }
    
    override func resignFirstResponder() ->Bool {
        super.resignFirstResponder()
        self.titleT.resignFirstResponder()
        self.contentT.resignFirstResponder()
        return true
    }
}

