//
//  MyWalletViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/23.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {

    var scrollWallet: UIScrollView!
    var lblPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Define.kColorBackGround()
        self.navigationItem.title = "我的钱包"
        
        let rightBarItem = UIBarButtonItem.init(title: "明星", style: UIBarButtonItemStyle.done, target: self, action: #selector(clickWithList))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    func setup() {
        
        scrollWallet = UIScrollView.init()
        scrollWallet.backgroundColor = UIColor.clear
        scrollWallet.showsVerticalScrollIndicator = false
        scrollWallet.showsHorizontalScrollIndicator = true
        self.view.addSubview(scrollWallet)
        scrollWallet.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let imageWallet = UIImageView.init()
        imageWallet.backgroundColor = UIColor.clear
        imageWallet.image = UIImage.init(named: "purse")
        scrollWallet.addSubview(imageWallet)
        imageWallet.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 143.0, height: 143.0))
            make.centerX.equalTo(self.scrollWallet)
            make.top.equalTo(80.0)
        }
        
        let lblBalance = UILabel.init()
        lblBalance.backgroundColor = UIColor.clear
        lblBalance.text = "余额"
        lblBalance.font = UIFont.systemFont(ofSize: 20.0)
        lblBalance.textColor = Define.kColorBlack()
        lblBalance.textAlignment = NSTextAlignment.center
        scrollWallet.addSubview(lblBalance)
        lblBalance.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100.0, height: 20.0))
            make.centerY.equalTo(self.scrollWallet)
            make.top.equalTo(20.0)
        }
        
        lblPrice = UILabel.init()
        lblPrice.backgroundColor = UIColor.clear
        lblPrice.textColor = Define.kColorBlack()
        lblPrice.font = UIFont.systemFont(ofSize: 35.0)
        lblPrice.textAlignment = NSTextAlignment.center
        lblPrice.text = "¥99.56"
        scrollWallet.addSubview(lblPrice)
        lblPrice.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 300.0, height: 35.0))
            make.centerY.equalTo(self.scrollWallet)
            make.top.equalTo(lblBalance.snp.bottom).offset(5.0)
        }
        
//        let btnTopUp = UIButton.init(type: UIButtonType.custom)
//        btnTopUp.backgroundColor = UIColor.
        
    }
    
    // MARK: - Action func
    func clickWithList() {
        
    }
}
