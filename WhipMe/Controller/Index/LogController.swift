//
//  LogController.swift
//  WhipMe
//
//  Created by Song on 2016/9/26.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class LogTextCell: NormalCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
}

class LogPhotoCell: UITableViewCell {
    
}

class LogLocationCell: UITableViewCell {
    
}


class LogController: UIViewController {

    var myLogTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setup() -> Void {
        self.navigationItem.title = "记录一下"
        self.view.backgroundColor = KColorBackGround
        myLogTable = UITableView.init()
//        myLogTable.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.cellReuseIdentifier())
        myLogTable.delegate = self
        myLogTable.dataSource = self
        myLogTable.isScrollEnabled = false
        self.view.addSubview(myLogTable)
        myLogTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let OKBtn = UIBarButtonItem.init()
        self.navigationItem.rightBarButtonItem = OKBtn
        
        weak var weakSelf = self
        OKBtn.bk_init(withTitle: "发送", style: .plain) { (sender) in
           
        }
    }
}

extension LogController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
        return cell
    }

}

extension LogController :UITableViewDelegate {
    
}
