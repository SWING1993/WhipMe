//
//  LogController.swift
//  WhipMe
//
//  Created by Song on 2016/9/26.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LogTextCell: NormalCell {
    
    var contentT : UIPlaceHolderTextView!
    var contentChangedBlock : ((String) -> Void)?
    var disposeBag = DisposeBag()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if contentT == nil {
            contentT = UIPlaceHolderTextView.init()
            contentT.font = UIFont.systemFont(ofSize: 15)
            contentT.placeholder = "记录一下"
            self.bgView.addSubview(contentT)
            contentT.snp.makeConstraints({ (make) in
                make.height.equalTo(155)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(10)
            })
        }
        
        let contentChange = contentT.rx.text
        contentChange
            .bindNext({ (value) in
                if self.contentChangedBlock != nil {
                    self.contentChangedBlock!(value)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    class func cellHeight() -> CGFloat {
        return 169
    }
    
    class func cellReuseIdentifier() -> String {
        return "LogTextCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LogPhotoCell: NormalCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    
    class func cellHeight(image: UIImage?) -> CGFloat {
        if image != nil {
            return Define.screenWidth() - 18
        }
        return 84
    }

    class func cellReuseIdentifier() -> String {
        return "LogPhotoCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LogLocationCell: NormalCell {
 
    var titleL: UILabel!
    var cellSwitch: UISwitch!
    var locationL: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if titleL == nil {
            titleL = UILabel.init()
            titleL.font = UIFont.systemFont(ofSize: 15)
            titleL.text = "显示位置"
            self.bgView.addSubview(titleL)
            titleL.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(0)
                make.height.equalTo(46)
            })
            
            let line = UIView.init()
            line.backgroundColor = UIColor.random()
            self.bgView.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(titleL.snp.bottom)
                make.height.equalTo(0.5)
            }
        }
        
        if cellSwitch == nil {
            cellSwitch = UISwitch.init()
            cellSwitch.isOn = false
            self.bgView.addSubview(cellSwitch)
            cellSwitch.snp.makeConstraints({ (make) in
                make.right.equalTo(-10)
                make.height.equalTo(30)
                make.top.equalTo(8)
                make.width.equalTo(55)
            })
        }
        
        if locationL == nil {
            locationL = UILabel.init()
            locationL.font = UIFont.systemFont(ofSize: 11)
            self.bgView.addSubview(locationL)
            locationL.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(titleL.snp.bottom)
                make.height.equalTo(33)
            })
        }
    }
    
    class func cellHeight() -> CGFloat {
        return 79
    }
    
    class func cellReuseIdentifier() -> String {
        return "LogLocationCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class LogController: UIViewController {

    var myLogTable: UITableView!

    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setup() -> Void {
        self.navigationItem.title = "记录一下"
        self.view.backgroundColor = Define.kColorBackGround()
        myLogTable = UITableView.init()
        myLogTable.backgroundColor = KColorBackGround
        myLogTable.register(LogTextCell.self, forCellReuseIdentifier: LogTextCell.cellReuseIdentifier())
        myLogTable.register(LogPhotoCell.self, forCellReuseIdentifier: LogPhotoCell.cellReuseIdentifier())
        myLogTable.register(LogLocationCell.self, forCellReuseIdentifier: LogLocationCell.cellReuseIdentifier())
        myLogTable.separatorStyle = .none
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
        
        if indexPath.row == 0 {
            let cell: LogTextCell = LogTextCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LogTextCell.cellReuseIdentifier())
            return cell
        }
        
        if indexPath.row == 1 {
            let cell: LogPhotoCell = LogPhotoCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LogPhotoCell.cellReuseIdentifier())
            return cell
        }
        
        if indexPath.row == 2 {
            let cell: LogLocationCell = LogLocationCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LogLocationCell.cellReuseIdentifier())
            return cell
        }
        let cell:UITableViewCell = UITableViewCell.init()
        return cell
    }
}

extension LogController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return LogTextCell.cellHeight()
        }
        if indexPath.row == 1 {
            return LogPhotoCell.cellHeight(image: self.image)
        }
        if indexPath.row == 2 {
            return LogLocationCell.cellHeight()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
            weak var weakSelf = self
            let sheet = UIActionSheet.init(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            sheet.bk_addButton(withTitle: "拍照", handler: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let cameraPicker = UIImagePickerController.init()
                    cameraPicker.delegate = self
                    cameraPicker.allowsEditing = true
                    cameraPicker.sourceType = .camera
                    weakSelf?.present(cameraPicker, animated: true, completion: {
                    })
                }
            })
            
            sheet.bk_addButton(withTitle: "从手机相册选取", handler: {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePickerC = UIImagePickerController.init()
                    imagePickerC.delegate = self
                    imagePickerC.allowsEditing = true
                    imagePickerC.sourceType = .photoLibrary
                    weakSelf?.present(imagePickerC, animated: true, completion: {
                    })
                }
            })
            
            sheet.show(in: self.view)
        }
    }
}

extension LogController :UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.image = image
        self.myLogTable.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }
}

extension LogController :UINavigationControllerDelegate {

}
