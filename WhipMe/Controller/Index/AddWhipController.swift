//
//  AddWhipController.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class AddWhipController: UIViewController {

    var disposeBag = DisposeBag()

    var myCostomAM = PlanM.init()

    fileprivate var customTable: UITableView!
    fileprivate var hotTable: UITableView!
    fileprivate var submitBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        self.submitBtn = UIBarButtonItem.init()
        self.submitBtn.bk_init(withTitle: "提交", style: .plain) { (sender) in
            PlanM.savePlan(value: self.myCostomAM)
            let time = self.myCostomAM.alarmClock?.timeIntervalSinceNow
            if time != nil {
                AppDelegate.registerNotification(alertItme: time!)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
        prepareSegmented()
        prepareTableView()
    }
    
    fileprivate func prepareTableView() {
        customTable = UITableView.init()
        customTable.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)

        customTable.tag = 100
        customTable.register(FirstAddCustomCell.self, forCellReuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
        customTable.register(SecondAddCustomCell.self, forCellReuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
        customTable.register(ThirdAddCustomCell.self, forCellReuseIdentifier: ThirdAddCustomCell.cellReuseIdentifier())
        customTable.dataSource = self
        customTable.delegate = self
        customTable.showsVerticalScrollIndicator = false
        customTable.separatorStyle = .none
        view.addSubview(customTable)
        customTable.translatesAutoresizingMaskIntoConstraints = false
        customTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        hotTable = UITableView.init()
        hotTable.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        hotTable.tag = 101
        hotTable.register(HotAddCell.self, forCellReuseIdentifier: HotAddCell.cellReuseIdentifier())
        hotTable.dataSource = self
        hotTable.delegate = self
        hotTable.showsVerticalScrollIndicator = false
        hotTable.separatorStyle = .none
        view.addSubview(hotTable)
        hotTable.translatesAutoresizingMaskIntoConstraints = false
        hotTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        customTable.isHidden = true
        hotTable.isHidden = false
    }
    
    fileprivate func prepareSegmented() {
        let titles_nav: NSArray = ["热门","自定义"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = KColorNavigation
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.white
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithSegmentedItem), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segmentedView
    }
    
    func clickWithSegmentedItem(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            customTable.isHidden = true
            hotTable.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
        }
        if sender.selectedSegmentIndex == 1 {
            customTable.isHidden = false
            hotTable.isHidden = true
            self.navigationItem.rightBarButtonItem = self.submitBtn
        }
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        let cell = self.customTable.cellForRow(at: IndexPath.init(row: 0, section: 0))
        cell?.resignFirstResponder()
        return true
    }
}

/// TableViewDataSource methods.
extension AddWhipController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100 {
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell: FirstAddCustomCell = FirstAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
                
                weak var weakSelf = self
                cell.titleChangedBlock =  { (value) -> Void in
                    print("title:" + value)
                    weakSelf?.myCostomAM.title = value
                    
                }
                
                cell.contentChangedBlock =  { (value) -> Void in
                    print("content:" + value)
                    weakSelf?.myCostomAM.title = value
                }
                return cell
            }
            if indexPath.section == 1 {
                let cell: SecondAddCustomCell = SecondAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
                
                weak var weakSelf = self
                cell.privacydBlock = { (value:PlanM) -> Void in
                    weakSelf?.myCostomAM.privacy = value.privacy
                }
                
                cell.alarmClockBlock = { (value:PlanM) -> Void in
                    weakSelf?.myCostomAM.alarmClock = value.alarmClock
                }

                cell.backClosure = { (inputText:IndexPath) -> Void in
                    print(inputText);
                    _ = self.resignFirstResponder()
                    if inputText.row == 0 {
                        SGHDateView.sharedInstance.pickerMode = .date
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.cancelBlock = { () -> Void in
                            self.myCostomAM.startTime = nil
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getStartTimeK()), object: self.myCostomAM)
                        }
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            self.myCostomAM.startTime = date as NSDate?
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getStartTimeK()), object: self.myCostomAM)
                        }
                    }
                    
                    if inputText.row == 1 {
                        SGHDateView.sharedInstance.pickerMode = .date
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.cancelBlock = { () -> Void in
                            self.myCostomAM.endTime = nil
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getEndTimeK()), object: self.myCostomAM)
                        }
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            self.myCostomAM.endTime = date as NSDate?
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getEndTimeK()), object: self.myCostomAM)
                        }
                    }
                    
                    if inputText.row == 2 {
                        let alarmC = AlarmClockController.init()
                        self.navigationController?.pushViewController(alarmC, animated: true)
                    }

                    if inputText.row == 3 {
                        let privacyC = PrivacyViewController.init()
                        self.navigationController?.pushViewController(privacyC, animated: true)
                    }
                    
                }
                return cell
            }
            if indexPath.section == 2 {
                let cell: ThirdAddCustomCell = ThirdAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ThirdAddCustomCell.cellReuseIdentifier())
                return cell
            }
        }
        
        if tableView.tag == 101 {
            let cell: HotAddCell = HotAddCell.init(style: UITableViewCellStyle.default, reuseIdentifier: HotAddCell.cellReuseIdentifier())
            return cell
        }
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "subtitlecell")
        return cell
    }
}


/// UITableViewDelegate methods.
extension AddWhipController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 100 {
            if indexPath.row == 0 && indexPath.section == 0 {
                return FirstAddCustomCell.cellHeight()
            }
            if indexPath.section == 1 {
                return SecondAddCustomCell.cellHeight()
            }
            
            if indexPath.section == 2 {
                return ThirdAddCustomCell.cellHeight()
            }
        }
        
        if tableView.tag == 101 {
            return HotAddCell.cellHeight()
        }
        
        return 0
    }
}

extension AddWhipController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            _ = self.resignFirstResponder()
        }
    }
}
