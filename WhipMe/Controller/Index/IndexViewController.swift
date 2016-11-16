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
    
    var bgView: UIView!
    var whipMeTable: UITableView!
    
    lazy var modelArray: NSArray = {
        return NSArray()
    }()
    
    var checkPlan:((IndexPath) -> Void)?
    var deletePlan:((IndexPath) -> Void)?

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
        tip.backgroundColor = kColorBlack
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
//            whipMeTable.separatorStyle = .none
            whipMeTable.isScrollEnabled = false
            whipMeTable.showsVerticalScrollIndicator = false
            whipMeTable.rowHeight = 60
            whipMeTable.delegate = self
            whipMeTable.dataSource = self
            bgView.addSubview(whipMeTable)
            whipMeTable.snp.makeConstraints({ (make) in
                make.width.equalTo(bgView)
                make.left.equalTo(0)
                make.top.equalTo(tip.snp.bottom).offset(10)
                make.bottom.equalTo(0)
            })
        }
    }
    
    func updateDataWith(array: NSArray) {
        self.modelArray = array
        print(array)
        whipMeTable.reloadData()
    }
    
    class func cellHeight(array: NSArray) -> CGFloat {
        var height = 60 * CGFloat.init(array.count)
        height += 54
        return height
    }
    
    class func cellReuseIdentifier() -> String {
        return "WhipMeCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WhipMeCell: UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "uitableviewcell")
        cell.selectionStyle = .none
        
        let planM: PlanM = self.modelArray.object(at: indexPath.row) as! PlanM
        cell.textLabel?.text = planM.themeName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell.detailTextLabel?.text = planM.plan
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
        
        let playLabel = UILabel.init()
        playLabel.backgroundColor = kColorGreen
        playLabel.font = UIFont.systemFont(ofSize: 10)
        playLabel.layer.masksToBounds = true
        playLabel.layer.cornerRadius = 5
        playLabel.textColor = kColorWhite
        playLabel.text = "进行中"
        playLabel.textAlignment = .center
        cell.addSubview(playLabel)
        playLabel.snp.makeConstraints { (make) in
            make.height.equalTo(13)
            make.centerY.equalTo(cell.textLabel!)
            make.left.equalTo(cell.textLabel!.snp.right).offset(5)
            make.width.equalTo(37)
        }
        return cell
    }
}

extension WhipMeCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.checkPlan != nil {
            self.checkPlan!(indexPath)
        }
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.deletePlan != nil {
            self.deletePlan!(indexPath)
        }
    }
}

class WhipOthersCell: UITableViewCell {
    var bgView : UIView!
    var whipOtherTable :UITableView!

    var clickCell:((IndexPath) -> Void)?

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
        tip.backgroundColor = kColorRed
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
            whipOtherTable.delegate = self
            whipOtherTable.isScrollEnabled = false
            whipOtherTable.separatorStyle = .none
            whipOtherTable.showsVerticalScrollIndicator = false
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

extension WhipOthersCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.clickCell != nil {
            self.clickCell!(indexPath)
        }
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

class IndexViewController: UIViewController {
    
    fileprivate var myTable: UITableView!
    var disposeBag = DisposeBag()
    lazy var dataArray :NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataArray.removeAllObjects()
        if PlanM.getPlans() != nil {
            for (_, value) in PlanM.getPlans()!.enumerated() {
                self.dataArray.add(value)
            }
            self.myTable?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
//        HttpAPIClient.apiClientPOST("queryHotThemeList", params: nil, success: { (result) in
//            if (result != nil) {
//                print(result);
////                let json = JSON(result!)
////                let data  = json["data"][0]["userInfo"]
////                UserManager.storeUserData(data: data)
//            }
//        }) { (error) in
//            print(error as Any);
//        }

    }
    
    fileprivate func setup() {
        self.navigationItem.title = "鞭挞"
        self.dataArray = NSMutableArray.init()

        self.view.backgroundColor = Define.kColorBackGround()
        prepareTableView()  //TODO 蹦了，我也不知道怎么回事，就注释掉,你看下
        let addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clickWithRightBarItem))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    fileprivate func prepareTableView() {
        myTable = UITableView.init()
        myTable.backgroundColor = kColorBackGround
        myTable.register(WhipMeCell.self, forCellReuseIdentifier: WhipMeCell.cellReuseIdentifier())
        myTable.register(WhipOthersCell.self, forCellReuseIdentifier: WhipOthersCell.cellReuseIdentifier())
        myTable.dataSource = self
        myTable.delegate = self
        myTable.emptyDataSetSource = self
        myTable.emptyDataSetDelegate = self
        myTable.separatorStyle = .none
        myTable.showsVerticalScrollIndicator = false
        view.addSubview(myTable!)
        myTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickWithRightBarItem() {
        let addWhipC = AddWhipController.init()
        addWhipC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addWhipC, animated: true)
    }
}

/// TableViewDataSource methods.
extension IndexViewController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (self.dataArray?.count)!
        if self.dataArray.count > 0 {
            return 1
        }
        return 0
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WhipMeCell = WhipMeCell.init(style: .default, reuseIdentifier: WhipMeCell.cellReuseIdentifier())
            cell.updateDataWith(array: self.dataArray)
            cell.checkPlan = { indexPath in
                print(indexPath)
                let addWhipC = LogController.init()
                addWhipC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addWhipC, animated: true)
            }
            
            cell.deletePlan = { indexPath in
                PlanM.deletePlan(index: indexPath.row);
                self.dataArray.removeObject(at: indexPath.row)
                self.myTable.reloadData()
            }
            return cell
        }
        let cell: WhipOthersCell = WhipOthersCell.init(style: .default, reuseIdentifier: WhipOthersCell.cellReuseIdentifier())
        return cell
    }
}


/// UITableViewDelegate methods.
extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || self.dataArray.count > 0 {
            return WhipMeCell.cellHeight(array: self.dataArray)
        }
        return 0
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

