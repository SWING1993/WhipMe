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
import CoreLocation

class LogTextCell: NormalCell {
    
    var contentT : UIPlaceHolderTextView!
//    var contentChangedBlock : ((String) -> Void)?
//    var disposeBag = DisposeBag()

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
        
//        let contentChange = contentT.rx.text
//        contentChange
//            .bindNext({ (value) in
//                if self.contentChangedBlock != nil {
//                    self.contentChangedBlock!(value)
//                }
//            })
//            .addDisposableTo(disposeBag)
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

class LogNoPhotoCell: NormalCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "camera_icon")
        self.bgView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.centerY.equalTo(self.bgView)
            make.centerX.equalTo(self.bgView).offset(-20)
        }
        
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.init(hexString: "#999999")
        label.text = "添加照片"
        self.bgView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(90)
            make.left.equalTo(imageView.snp.right).offset(5)
            make.centerY.equalTo(imageView)
        }
    
    }
    
    class func cellHeight() -> CGFloat {
        return 84
    }

    class func cellReuseIdentifier() -> String {
        return "LogNoPhotoCell"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LogPhotoCell: NormalCell {
    
    var photoView: UIImageView!
    var deleteBtn: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if photoView == nil {
            photoView = UIImageView.init()
            photoView.contentMode = .scaleAspectFill
            photoView.clipsToBounds = true
            photoView.isUserInteractionEnabled = true
            self.bgView.addSubview(photoView)
            photoView.snp.makeConstraints({ (make) in
                make.center.equalTo(self.bgView)
                make.height.width.equalTo(Define.screenWidth() - 50)
            })
        }
        
        if deleteBtn == nil {
            deleteBtn = UIButton.init(type: .custom)
            deleteBtn.setBackgroundImage(UIImage.init(named: "删除图片"), for: .normal)
            photoView.addSubview(deleteBtn)
            deleteBtn.snp.makeConstraints({ (make) in
                make.height.width.equalTo(27)
                make.right.equalTo(photoView)
                make.top.equalTo(photoView)
            })
        }
        
    }
    
    class func cellHeight(image: UIImage?) -> CGFloat {
        return Define.screenWidth() - 18
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
    var switcher: UISwitch!
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
        
        if switcher == nil {
            switcher = UISwitch.init()
            switcher.isOn = false
            self.bgView.addSubview(switcher)
            switcher.snp.makeConstraints({ (make) in
                make.right.equalTo(-10)
                make.height.equalTo(30)
                make.top.equalTo(8)
                make.width.equalTo(55)
            })
        }
        
        if locationL == nil {
            locationL = UILabel.init()
            locationL.font = UIFont.systemFont(ofSize: 11)
            locationL.baselineAdjustment = .alignCenters
            self.bgView.addSubview(locationL)
            locationL.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(titleL.snp.bottom).offset(-5)
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
    var photo: UIImage?
    var location: String?
    var disposeBag = DisposeBag()

    lazy var locateM : CLLocationManager = {
        let locate  = CLLocationManager()
        locate.delegate = self
        locate.requestWhenInUseAuthorization()
        return locate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
      
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func choosePhoto() {
        let sheet = UIActionSheet.init(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        sheet.bk_addButton(withTitle: "拍照", handler: {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController.init()
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = .camera
                self.present(cameraPicker, animated: true, completion: {
                })
            }
        })
        
        sheet.bk_addButton(withTitle: "从手机相册选取", handler: {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerC = UIImagePickerController.init()
                imagePickerC.delegate = self
                imagePickerC.allowsEditing = true
                imagePickerC.sourceType = .photoLibrary
                self.present(imagePickerC, animated: true, completion: {
                })
            }
        })
        
        sheet.show(in: self.view)
    }
    
    func getLocation() {
        self.locateM.startUpdatingLocation()
    }
    
    func setup() -> Void {
        self.navigationItem.title = "记录一下"
        self.view.backgroundColor = Define.kColorBackGround()
        myLogTable = UITableView.init()
        myLogTable.backgroundColor = KColorBackGround
        myLogTable.register(LogTextCell.self, forCellReuseIdentifier: LogTextCell.cellReuseIdentifier())
        myLogTable.register(LogNoPhotoCell.self, forCellReuseIdentifier: LogNoPhotoCell.cellReuseIdentifier())
        myLogTable.register(LogPhotoCell.self, forCellReuseIdentifier: LogPhotoCell.cellReuseIdentifier())
        myLogTable.register(LogLocationCell.self, forCellReuseIdentifier: LogLocationCell.cellReuseIdentifier())
        myLogTable.separatorStyle = .none
        myLogTable.delegate = self
        myLogTable.dataSource = self
        self.view.addSubview(myLogTable)
        myLogTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let OKBtn = UIBarButtonItem.init()
        self.navigationItem.rightBarButtonItem = OKBtn
        
        OKBtn.bk_init(withTitle: "发送", style: .plain) { (sender) in
            HttpClient.sharedInstance.apiRequest(url: "", parameters: ["consumer_key": "123"], method: .get, completionHandler: { (requst, error) in
                print(requst)
                print(error)
            })
        }
        self.getLocation()
        self.myLogTable.rx.itemSelected
            .subscribe { (index) in
                if index.element?.row == 1 && self.photo == nil {
                    self.choosePhoto()
                }
            }
            .addDisposableTo(disposeBag)
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
            cell.contentT.rx.text
                .bindNext({ (value) in
                    print(value)
                })
                .addDisposableTo(disposeBag)
            return cell
        }
        
        if indexPath.row == 1 {
            if self.photo == nil {
                let cell: LogNoPhotoCell = LogNoPhotoCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LogNoPhotoCell.cellReuseIdentifier())
                return cell
            }
            let cell: LogPhotoCell = LogPhotoCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LogPhotoCell.cellReuseIdentifier())
            cell.photoView.image = self.photo
            cell.deleteBtn.bk_addEventHandler({ (sender) in
                self.photo = nil
                self.myLogTable.reloadData()
                }, for: .touchUpInside)
            return cell
        }
        
        if indexPath.row == 2 {
            let cell: LogLocationCell = LogLocationCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LogLocationCell.cellReuseIdentifier())
            cell.locationL.text = self.location
            cell.switcher.rx.value
                .bindNext({ (isOn) in
                    cell.locationL.isHidden = !isOn
                    if isOn {
                        self.getLocation()
                    }
                    else {
                        self.location = nil
                    }
                })
            .addDisposableTo(disposeBag)
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
            if self.photo == nil {
                return LogNoPhotoCell.cellHeight()
            }
            return LogPhotoCell.cellHeight(image: self.photo)
        }
        if indexPath.row == 2 {
            return LogLocationCell.cellHeight()
        }
        return 0
    }
}

extension LogController :UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.photo = image
        self.myLogTable.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension LogController :UINavigationControllerDelegate {

}

extension LogController :CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
        manager.stopUpdatingHeading()
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placemarks, error) in
            if error == nil {
                let mark = placemarks?.last
                print(mark?.name)
                self.location = mark?.name
                let cell:LogLocationCell = self.myLogTable.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! LogLocationCell
                cell.locationL.text = self.location
            }else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
