//
//  UserInfoViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tableViewWM: UITableView!
//    var arrayContent: NSMutableArray! = ["","头像","","昵称","性别","生日","","签名"]
    var userModel: UserInfoModel!
    
    var sheetSex: UIActionSheet!
    var sheetAvatar: UIActionSheet!
    
    private let identifier_cell: String = "userInfoViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "编辑个人资料"
        self.view.backgroundColor = Define.kColorBackGround()
        
        if (userModel == nil) {
            userModel = UserInfoModel()
            userModel.username = "幽叶"
            userModel.nickname = "榴莲"
            userModel.avatar = "system_monitoring"
            userModel.sex = "男"
            userModel.age = "22"
            userModel.birthday = "1992-10-05"
            userModel.signature = "寂寞的幻境，朦胧的身影"
        }
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        tableViewWM = UITableView.init()
        tableViewWM.backgroundColor = UIColor.clear
        tableViewWM.delegate = self
        tableViewWM.dataSource = self
        tableViewWM.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableViewWM.separatorColor = Define.kColorLine()
        tableViewWM.separatorInset = UIEdgeInsets.zero
        tableViewWM.layoutMargins = UIEdgeInsets.zero
        tableViewWM.tableFooterView = UIView.init()
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        tableViewWM.register(UserInfoTableViewCell.classForCoder(), forCellReuseIdentifier: UserInfoTableViewCell.cellReuseIdentifier())
        
        sheetAvatar = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"拍照","图库")
        sheetSex = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "女", "男")
    }
    
    // MARK: - Action func
    func showUserEditContorl(indexPath: IndexPath, placeholder: String) {
        let editControl: EditControlType = indexPath.row == 7 ? EditControlType.signature : EditControlType.nickname
        let controller: UserEditViewController = UserEditViewController()
        controller.editControl = editControl
        controller.strPlaceholder = placeholder
        controller.textEditedBlock = { (value, editType) -> Void in
            print("value is :\(value) __:\(editType)")
            if editType == EditControlType.signature {
                self.userModel.signature = value
            } else {
                self.userModel.nickname = value
            }
            self.tableViewWM.reloadData()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func selectUserBirthday() {
        SGHDateView.sharedInstance.pickerMode = .date
        SGHDateView.sharedInstance.show();
        
//        let format = DateFormatter()
//        format.dateFormat = "yyyy-MM-dd"
//        format.timeZone = TimeZone.init(identifier: "Asia/Beijing")
        
        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.userModel.birthday = formatter.string(from: date as Date)
            self.tableViewWM.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0.0
        if indexPath.row == 0 {
            rowHeight = 10.0
        } else if (indexPath.row == 2 || indexPath.row == 6) {
            rowHeight = 12.0
        } else if (indexPath.row == 1) {
            rowHeight = 75.0
        } else {
            rowHeight = 48.0
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.cellReuseIdentifier()) as! UserInfoTableViewCell
        cell.backgroundColor = UIColor.white
        cell.imageLogo.isHidden = true
        cell.lblText.isHidden = false
        
        var margin_x: CGFloat = 0.0
        if indexPath.row == 1 {
            cell.lblTitle?.text = "头像"
            cell.lblText.isHidden = true
            cell.imageLogo.isHidden = false
            cell.imageLogo.backgroundColor = Define.kColorLight()
//            cell.imageLogo.image = UIImage.init(named: userModel.avatar)
            cell.imageLogo.image = UIImage.full(toFilePath: userModel.avatar)
        } else if indexPath.row == 3 {
            cell.lblTitle?.text = "昵称"
            cell.lblText.text = userModel.nickname
            margin_x = 15.0
        } else if indexPath.row == 4 {
            cell.lblTitle?.text = "性别"
            cell.lblText.text = userModel.sex
            margin_x = 15.0
        } else if indexPath.row == 5 {
            cell.lblTitle?.text = "生日"
            cell.lblText.text = userModel.birthday
        } else if indexPath.row == 7 {
            cell.lblTitle?.text = "签名"
            cell.lblText.text = userModel.signature
        } else {
            cell.lblTitle?.text = ""
            cell.backgroundColor = UIColor.clear
        }
        cell.layoutMargins = UIEdgeInsets.init(top: 0, left: margin_x, bottom: 0, right: 0)
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: margin_x, bottom: 0, right: 0)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell: UserInfoTableViewCell = tableView.cellForRow(at: indexPath) as! UserInfoTableViewCell
        
        if indexPath.row == 1 {
            
            sheetAvatar.show(in: self.view)
        } else if (indexPath.row == 3 || indexPath.row == 7) {
            showUserEditContorl(indexPath: indexPath, placeholder: cell.lblText.text!)
        } else if indexPath.row == 4 {
            
            sheetSex.show(in: self.view)
        } else if indexPath.row == 5 {
            selectUserBirthday()
        }
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print("sheet is index:\(buttonIndex)")
        
        if buttonIndex == 0 {
            return
        }
        
        if actionSheet == sheetSex {
            
            userModel.sex = buttonIndex == 1 ? "女" : "男"
            self.tableViewWM.reloadData()
        } else if actionSheet == sheetAvatar {
        
            let imagePicker = UIImagePickerController.init()
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            imagePicker.videoQuality = UIImagePickerControllerQualityType.typeHigh
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            if buttonIndex == 1 {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear
                } else {
                    let alertView = UIAlertView.init(title: "该设备不支持“照相机”", message: nil, delegate: nil, cancelButtonTitle: "取消")
                    alertView.show()
                    return
                }
            } else if buttonIndex == 2 {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
                } else {
                    let alertView = UIAlertView.init(title: "该设备不支持“相片库”", message: nil, delegate: nil, cancelButtonTitle: "取消")
                    alertView.show()
                    return
                }
            }
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let imageEdited: UIImage = UIImage.fixOrientation(info[UIImagePickerControllerEditedImage] as! UIImage!)
        let newImge: UIImage = UIImage.scale(imageEdited)
        
        let imageData: NSData = UIImage.dataRepresentationImage(newImge) as NSData
        
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let fullFile: String = filePath.appending("/"+UIImage.generateUuidString()+".png")
        
        print("full file is :\(fullFile)")
        let file_url = NSURL.init(string: fullFile)
        
        print("lastPathComponent is :\(file_url?.lastPathComponent)")
        
        let flag: Bool = imageData.write(toFile: fullFile, atomically: true)
        if flag {
            userModel.avatar = file_url?.lastPathComponent
            self.tableViewWM.reloadData()
        }
        
    }
    
}
