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

    
    fileprivate var customTable: UITableView!
    fileprivate var hotTable: UITableView!

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
        }
        if sender.selectedSegmentIndex == 1 {
            customTable.isHidden = false
            hotTable.isHidden = true
        }
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
                return cell
            }
            if indexPath.section == 1 {
                let cell: SecondAddCustomCell = SecondAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
                cell.setBackMyClosure { (inputText:IndexPath) -> Void in
                    print(inputText);
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
    
    //    /// Sets the tableView header height.
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 200
    //    }
    //    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 15
    //    }
    
}