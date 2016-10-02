//
//  IndexViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class WhipMeCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    var bgView : UIView!
    var whipMeTable :UITableView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = Define.kColorBackGround()
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(21)
                make.bottom.equalTo(kBottomMargin)
                make.left.equalTo(kLeftMargin)
                make.right.equalTo(kRightMargin)
            }
        }
        
        
        let tip = UILabel.init()
        tip.text = "鞭挞我"
        tip.textColor = UIColor.white
        tip.font = UIFont.systemFont(ofSize: 10)
        tip.textAlignment = .center
        tip.backgroundColor = KColorBlack
        tip.layer.masksToBounds = true
        tip.layer.cornerRadius = 36/2
        self.addSubview(tip)
        tip.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.top.equalTo(8)
            make.left.equalTo(14.5)
        }
       
        if whipMeTable == nil {
            whipMeTable = UITableView.init()
            whipMeTable.separatorStyle = .none
            whipMeTable.isScrollEnabled = false
            whipMeTable.backgroundColor = UIColor.random()
            bgView.addSubview(whipMeTable)
            whipMeTable.snp.makeConstraints({ (make) in
                make.width.equalTo(bgView)
                make.left.equalTo(0)
                make.top.equalTo(tip.snp.bottom).offset(10)
                make.bottom.equalTo(0)
            })
        }
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
            ])
        
        items
            .bindTo(whipMeTable.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
        
    }
    
    class func cellHeight() -> CGFloat {
        return 400
    }
    
    class func cellReuseIdentifier() -> String {
        return "WhipMeCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WhipOthersCell: UITableViewCell {
    var bgView : UIView!
    var whipOtherTable :UITableView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = Define.kColorBackGround()
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(21)
                make.bottom.equalTo(kBottomMargin)
                make.left.equalTo(kLeftMargin)
                make.right.equalTo(kRightMargin)
            }
        }
        
        let tip = UILabel.init()
        tip.text = "鞭挞他"
        tip.textColor = UIColor.white
        tip.font = UIFont.systemFont(ofSize: 10)
        tip.textAlignment = .center
        tip.backgroundColor = KColorRed
        tip.layer.masksToBounds = true
        tip.layer.cornerRadius = 36/2
        self.addSubview(tip)
        tip.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.top.equalTo(8)
            make.left.equalTo(14.5)
        }
        
        if whipOtherTable == nil {
            whipOtherTable = UITableView.init()
            whipOtherTable.isScrollEnabled = false
            whipOtherTable.separatorStyle = .none
            whipOtherTable.backgroundColor = UIColor.random()
            bgView.addSubview(whipOtherTable)
            whipOtherTable.snp.makeConstraints({ (make) in
                make.width.equalTo(bgView)
                make.left.equalTo(0)
                make.top.equalTo(tip.snp.bottom).offset(10)
                make.bottom.equalTo(0)
            })
        }
  
    }
    
    class func cellHeight() -> CGFloat {
        return 400
    }
    
    class func cellReuseIdentifier() -> String {
        return "WhipOthersCell"
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IndexViewController: UIViewController {
    
    fileprivate var myTable: UITableView!
    var disposeBag = DisposeBag()
    var dataArray :NSMutableArray?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataArray?.removeAllObjects()
        if PlanM.getPlans() != nil {
            for (_, value) in PlanM.getPlans()!.enumerated() {
                self.dataArray?.add(value)
            }
            self.myTable?.reloadData()
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    fileprivate func setup() {
        self.navigationItem.title = "鞭挞"
        self.dataArray = NSMutableArray.init()

        self.view.backgroundColor = Define.kColorBackGround()
//        prepareTableView()  //TODO 蹦了，我也不知道怎么回事，就注释掉,你看下
        let addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clickWithRightBarItem))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    fileprivate func prepareTableView() {
        myTable = UITableView.init()
        myTable.backgroundColor = KColorBackGround
        myTable.register(WhipMeCell.self, forCellReuseIdentifier: WhipMeCell.cellReuseIdentifier())
        myTable.register(WhipOthersCell.self, forCellReuseIdentifier: WhipOthersCell.cellReuseIdentifier())
        myTable?.dataSource = self
        myTable?.delegate = self
        myTable?.emptyDataSetSource = self
        myTable?.emptyDataSetDelegate = self
        myTable?.separatorStyle = .none
        view.addSubview(myTable!)
        myTable?.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickWithRightBarItem() {
//        let addWhipC = AddWhipController.init()
//        addWhipC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(addWhipC, animated: true)
        let addWhipC = LogController.init()
        addWhipC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addWhipC, animated: true)
    }
}

/// TableViewDataSource methods.
extension IndexViewController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (self.dataArray?.count)!
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WhipMeCell = WhipMeCell.init(style: .default, reuseIdentifier: WhipMeCell.cellReuseIdentifier())

  
            return cell
        }
        let cell: WhipOthersCell = WhipOthersCell.init(style: .default, reuseIdentifier: WhipOthersCell.cellReuseIdentifier())
        return cell
        
        /*
        let cell:UITableViewCell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        
        let model:PlanM? = self.dataArray?.object(at: indexPath.row) as! PlanM?
        cell.textLabel?.text = model?.title
        
        
        var str :String = String.init()
        
        if model?.alarmClock != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let alarmS = "提醒时间：" + formatter.string(from: (model?.alarmClock)! as Date)
            str.append(alarmS)
        }
        
        if model?.startTime != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let alarmS = "开始时间：" + formatter.string(from: (model?.startTime)! as Date)
            str.append(alarmS)
        }

        if model?.endTime != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let alarmS = "结束时间：" + formatter.string(from: (model?.endTime)! as Date)
            str.append(alarmS)
        }
        cell.detailTextLabel?.text = str
        
        return cell
 */
    }
}


/// UITableViewDelegate methods.
extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension IndexViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let emptyStr = NSAttributedString.init(string: "您还没有添加任何习惯哦\n快来添加吧！", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)])
        return emptyStr
    }
    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        let emptyImg = UIImage.init(named: "no_data")
//        return emptyImg
//    }
}

extension IndexViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

