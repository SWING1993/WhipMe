//
//  SecondAddCustomCell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class SecondAddCustomCell: UITableViewCell {

    var bgView : UIView!
    var table : UITableView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        self.selectionStyle = .none
        
        
        
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(9)
                make.bottom.equalTo(0)
                make.left.equalTo(9)
                make.right.equalTo(-9)
            }
        }
        
        if table == nil {
            table = UITableView.init()
            table.dataSource = self
            table.delegate = self
            table.isScrollEnabled = false
            bgView.addSubview(table)
            table.snp.makeConstraints { (make) in
                make.top.equalTo(2)
                make.left.right.equalTo(0)
                make.height.equalTo(200)
            }
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
    }
    
    class func cellHeight() -> CGFloat {
        return 210
    }
    
    class func cellReuseIdentifier() -> String {
        return "SecondAddCustomCell"
    }
}

/// TableViewDataSource methods.
extension SecondAddCustomCell:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.textLabel?.text = "1234"
        return cell
    }
}


/// UITableViewDelegate methods.
extension SecondAddCustomCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

