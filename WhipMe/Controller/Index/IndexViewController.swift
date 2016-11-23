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
import SwiftyJSON

class WhipM: NSObject {
    
    var accept: Int = 0
    var type: Int = 0
    var going: Int = 0
    var guarantee: CGFloat = 0.00
    var recordNum:Int = 0
    
    var createDate: String = ""
    var startDate: String = ""
    var endDate: String = ""

    
    var creator: String = ""
    var icon: String = ""
    var result: String = ""
    var plan: String = ""
    
    var taskId: String = ""
    var themeIcon: String = ""
    var themeId: String = ""
    var themeName: String = ""
    
    var supervisor: String = ""
    var supervisorName: String = ""
    var supervisorIcon: String = ""
}

class WhipMeCell: UITableViewCell {
    
    
    var headV: UIImageView = UIImageView.init()
    var themeV: UIImageView = UIImageView.init()
    
    var themeL: UILabel = UILabel.init()
    var goingL: UILabel = UILabel.init()
    
    var subTitle: UILabel = UILabel.init()
    
    var guaranteeL: UILabel = UILabel.init()
    var refuseBtn: UIButton = UIButton.init()
    var acceptBtn: UIButton = UIButton.init()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kColorWhite
        
        
        headV.layer.cornerRadius = 40/2
        headV.layer.masksToBounds = true
        headV.backgroundColor = UIColor.random()
        self.contentView .addSubview(headV)
        headV.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(15)
            make.right.equalTo(-9)
        }

        
//        iconV.backgroundColor = UIColor.random()
        themeV.layer.cornerRadius = 30/2
        themeV.layer.masksToBounds = true
        self.contentView .addSubview(themeV)
        themeV.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerY.equalTo(headV.snp.centerY)
            make.left.equalTo(18)
        }
        
        
        themeL.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(themeL)
        themeL.snp.makeConstraints { (make) in
            make.left.equalTo(themeV.snp.right).offset(16)
            make.top.equalTo(headV.snp.top)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        
        goingL.font = UIFont.systemFont(ofSize: 10)
        goingL.layer.masksToBounds = true
        goingL.layer.cornerRadius = 7
        goingL.textColor = kColorWhite
        goingL.textAlignment = .center
        self.contentView.addSubview(goingL)
        goingL.snp.makeConstraints { (make) in
            make.left.equalTo(themeL.snp.right).offset(7)
            make.centerY.equalTo(themeL)
            make.height.equalTo(14)
            make.width.equalTo(40)
        }
        
//        subTitle.backgroundColor = UIColor.random()
        subTitle.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(themeV.snp.right).offset(16)
            make.top.equalTo(themeL.snp.bottom)
            make.height.equalTo(themeL)
            make.width.equalTo(150)
        }
    }
    
    func config() {
        let line: UIView = UIView.init()
        line.backgroundColor = Define.RGBColorAlphaFloat(153, g: 153, b: 153, a: 0.5)
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(themeL)
            make.right.equalTo(-3)
            make.height.equalTo(0.5)
            make.top.equalTo(75.5)
        }
        
        guaranteeL.font = UIFont.systemFont(ofSize: 10)
        guaranteeL.textColor = kColorRed
        self.contentView.addSubview(guaranteeL)
        guaranteeL.snp.makeConstraints { (make) in
            make.left.equalTo(line)
            make.height.equalTo(22)
            make.top.equalTo(line.snp.bottom).offset(11)
            make.width.equalTo(100)
        }
        
        
        acceptBtn.backgroundColor = kColorBlue
        acceptBtn.layer.cornerRadius = 11
        acceptBtn.layer.masksToBounds = true
        acceptBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        acceptBtn.setTitleColor(kColorWhite, for: .normal)
        acceptBtn.setTitle("接受", for: .normal)
        self.contentView.addSubview(acceptBtn)
        acceptBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(50)
            make.right.equalTo(-9)
            make.centerY.equalTo(guaranteeL)
        }
        
        
        refuseBtn.backgroundColor = kColorGolden
        refuseBtn.layer.cornerRadius = 11
        refuseBtn.layer.masksToBounds = true
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        refuseBtn.setTitleColor(kColorWhite, for: .normal)
        refuseBtn.setTitle("接受", for: .normal)
        self.contentView.addSubview(refuseBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(50)
            make.right.equalTo(acceptBtn.snp.left).offset(-12)
            make.centerY.equalTo(guaranteeL)
        }
        
    
    }
    
    class func whipOtherCellHeight(model:WhipM) -> CGFloat {
        var height: CGFloat = 75.0
        if model.accept == 0 {
            height += 44
        }
        return height
    }
    
    class func whipMeCellHeight() -> CGFloat {
        return 75.0
    }
    
//    class func whipMeCellHeight(model:WhipM) -> CGFloat {
//        return 75.0
//    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WhipCell: UITableViewCell {
    
    var bgView: UIView!
    var whipMeTable: UITableView!
    
    lazy var modelArray: NSArray = {
        return NSArray()
    }()
    
    var myReuseIdentifier: String = ""
    
    var checkPlan:((IndexPath) -> Void)?
    var deletePlan:((IndexPath) -> Void)?
    
    var sectionHArr_Me: NSArray = NSArray.init()
    var sectionHArr_Other: NSArray = NSArray.init()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = Define.kColorBackGround()
        self.myReuseIdentifier = reuseIdentifier!
        
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
        
        if reuseIdentifier == WhipCell.whipMeReuseIdentifier() {
            tip.text = "鞭挞我"
            tip.backgroundColor = kColorBlack
        } else {
            tip.text = "鞭挞他"
            tip.backgroundColor = kColorRed
        }
       
        tip.textColor = UIColor.white
        tip.font = UIFont.systemFont(ofSize: 10)
        tip.textAlignment = .center
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
            whipMeTable.isScrollEnabled = false
            whipMeTable.showsVerticalScrollIndicator = false
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
    
    //return WhipMeCell.whipOtherCellHeight(model: whipM)
    //return WhipMeCell.whipMeCellHeight()
    func setDataWith(array: NSArray) {
        self.modelArray = array
        
        
        self.sectionHArr_Other = {
            let tempArr: NSMutableArray = NSMutableArray.init()
            for whipM in array {
                let height:CGFloat = WhipMeCell.whipOtherCellHeight(model: whipM as! WhipM)
                tempArr.add(height)
            }
            return tempArr.copy() as! NSArray
        }()

        
        self.sectionHArr_Me = {
            let tempArr: NSMutableArray = NSMutableArray.init()
            for _ in array {
                let height:CGFloat = WhipMeCell.whipMeCellHeight()
                tempArr.add(height)
            }
            return tempArr.copy() as! NSArray
        }()
        
        self.whipMeTable.reloadData()
    }
    
    class func cellHeight(array: NSArray, type: String) -> CGFloat {
        var height: CGFloat = 54.0
        if type == whipOtherReuseIdentifier() {
            for whipM in array {
                height += WhipMeCell.whipOtherCellHeight(model: whipM as! WhipM)
            }
        }
        else {
            for _ in array {
                height += WhipMeCell.whipMeCellHeight()
            }
        }
        return height
    }
    
    class func whipMeReuseIdentifier() -> String {
        return "WhipMeCell"
    }
    
    class func whipOtherReuseIdentifier() -> String {
        return "WhipOtherCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WhipCell: UITableViewDataSource {
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
        let cell: WhipMeCell = WhipMeCell.init(style: .subtitle, reuseIdentifier: self.myReuseIdentifier)
        
        let whipM: WhipM = self.modelArray.object(at: indexPath.row) as! WhipM
        
        cell.themeV.setImageWith(urlString: whipM.themeIcon, placeholderImage: "zaoqi")
        cell.headV.setImageWith(urlString: whipM.icon, placeholderImage: "zaoqi")
        
        cell.themeL.text = whipM.themeName
        let themeLWidth = whipM.themeName.getWidth(font: UIFont.systemFont(ofSize: 14), height: 20)
        cell.themeL.snp.updateConstraints { (make) in
            make.width.equalTo(themeLWidth)
        }
        cell.subTitle.text = whipM.plan

        // 鞭挞他
        if self.myReuseIdentifier == WhipCell.whipOtherReuseIdentifier() {
            if whipM.going == 0 {
                cell.goingL.text = "进行中"
                cell.goingL.backgroundColor = kColorGreen

            } else {
                cell.goingL.text = "已结束"
                cell.goingL.backgroundColor = kColorRed
            }
            if whipM.accept == 0 {
                cell.config()
                cell.guaranteeL.text = "保证金："+String(describing: whipM.guarantee)+"元"
            }
        }
        // 鞭挞我
        else {
            if whipM.accept == 0 {
                cell.goingL.text = "待确认"
                cell.goingL.backgroundColor = kColorYellow

            } else if whipM.accept == 1 {
                cell.goingL.text = "已拒绝"
                cell.goingL.backgroundColor = kColorRed
            } else {
                cell.goingL.isHidden = true
            }
        }
        return cell
    }
}

extension WhipCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.checkPlan != nil {
            self.checkPlan!(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.myReuseIdentifier == WhipCell.whipOtherReuseIdentifier() {
            return self.sectionHArr_Other.object(at: indexPath.row) as! CGFloat
            
        }else {
            return self.sectionHArr_Me.object(at: indexPath.row) as! CGFloat
        }
        /*
        let whipM: WhipM = self.modelArray.object(at: indexPath.row) as! WhipM
        if self.myReuseIdentifier == WhipCell.whipOtherReuseIdentifier() {
            return WhipMeCell.whipOtherCellHeight(model: whipM)

        }else {
            return WhipMeCell.whipMeCellHeight()

        }
        */
    }
}

class IndexViewController: UIViewController {
    
    fileprivate var myTable: UITableView!
    var disposeBag = DisposeBag()
    
    
    lazy var biantataList :NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    lazy var biantawoList :NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    var sectionH_0: CGFloat = 0.0
    var sectionH_1: CGFloat = 0.0

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        self.navigationItem.title = "鞭挞"

        self.view.backgroundColor = Define.kColorBackGround()
        prepareTableView()
        let addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clickWithRightBarItem))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    fileprivate func setupAPI() {
        let params = ["userId":UserManager.getUser().userId]
        HttpAPIClient.apiClientPOST("biantawoList", params: params, success: { (result) in
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let woList  = json["data"][0]["biantawoList"].arrayObject
                    let taList  = json["data"][0]["biantataList"].arrayObject
//                    print(result)
                    self.biantawoList = WhipM.mj_objectArray(withKeyValuesArray: woList)
                    self.biantataList = WhipM.mj_objectArray(withKeyValuesArray: taList)
                    self.sectionH_0 = WhipCell.cellHeight(array: self.biantataList, type: WhipCell.whipOtherReuseIdentifier())
                    self.sectionH_1 = WhipCell.cellHeight(array: self.biantawoList, type: WhipCell.whipMeReuseIdentifier())

                    self.myTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any);
        }
    }
    
    fileprivate func prepareTableView() {
        myTable = UITableView.init()
        myTable.backgroundColor = kColorBackGround
        myTable.register(WhipCell.self, forCellReuseIdentifier: WhipCell.whipMeReuseIdentifier())
        myTable.register(WhipCell.self, forCellReuseIdentifier: WhipCell.whipOtherReuseIdentifier())

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
        if section == 0 {
            if self.biantataList.count > 0 {
                return 1
            }
            return 0
        }
        
        if section == 1 {
            if self.biantawoList.count > 0 {
                return 1
            }
            return 0
        }
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WhipCell = WhipCell.init(style: .default, reuseIdentifier: WhipCell.whipOtherReuseIdentifier())
            cell.setDataWith(array: self.biantataList)
            
            /*
            cell.checkPlan = { indexPath in
                print(indexPath)
                let addWhipC = LogController.init()
                addWhipC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addWhipC, animated: true)
            }
            
            cell.deletePlan = { indexPath in
                PlanM.deletePlan(index: indexPath.row);
//                self.dataArray.removeObject(at: indexPath.row)
                self.myTable.reloadData()
            }
 */
            return cell
        }
        let cell: WhipCell = WhipCell.init(style: .default, reuseIdentifier: WhipCell.whipMeReuseIdentifier())
        cell.setDataWith(array: self.biantawoList)

        return cell
    }
}


/// UITableViewDelegate methods.
extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return sectionH_0
        }
        
        if indexPath.section == 1 {
            return sectionH_1
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

