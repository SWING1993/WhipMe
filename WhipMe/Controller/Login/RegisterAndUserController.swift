//
//  RegisterAndUserController.swift
//  WhipMe
//
//  Created by anve on 16/9/27.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class RegisterAndUserController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var mobile: String!
    public var password: String!
    private var userSex: String!
    private var avatar: String!
    private var nickname: String!
    
    // 微信首次登录
    
    private var btnAvatar: UIButton!
    private var txtNickname: UITextField!
    private var btnSubmit: UIButton!
    private var btnAgreement: UIButton!
    private var arrayButtonSex: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "创建账号"
        self.view.backgroundColor = Define.kColorBackGround()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        btnAvatar = UIButton.init(type: UIButtonType.custom)
        btnAvatar.backgroundColor = UIColor.clear
        btnAvatar.layer.cornerRadius = 31.0
        btnAvatar.layer.masksToBounds = true
        btnAvatar.setImage(UIImage.init(named: "button_addHeader_off"), for: UIControlState.normal)
        btnAvatar.setImage(UIImage.init(named: "button_addHeader_on"), for: UIControlState.highlighted)
        btnAvatar.addTarget(self, action: #selector(clickWithAvatar), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnAvatar)
        btnAvatar.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 62.0, height: 62.0))
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(45.0)
        }
        
        let lblAvatar = UILabel.init()
        lblAvatar.backgroundColor = UIColor.clear
        lblAvatar.textAlignment = NSTextAlignment.center
        lblAvatar.textColor = Define.kColorBlack()
        lblAvatar.font = kTitleFont
        lblAvatar.text = "添加头像"
        self.view.addSubview(lblAvatar)
        lblAvatar.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100.0, height: 16.0))
            make.centerX.equalTo(self.view)
            make.top.equalTo(btnAvatar.snp.bottom).offset(10.0)
        }
        
        txtNickname = UITextField.init()
        txtNickname.backgroundColor = UIColor.white
        txtNickname.font = kContentFont
        txtNickname.textAlignment = NSTextAlignment.left
        txtNickname.textColor = Define.kColorBlack()
        txtNickname.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        txtNickname.placeholder = "输入昵称"
        txtNickname.layer.cornerRadius = 4.0
        txtNickname.layer.masksToBounds = true
        txtNickname.delegate = self
        self.view.addSubview(txtNickname)
        
        let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10.0, height: 0))
        viewLeft.backgroundColor = UIColor.clear
        txtNickname.leftView = viewLeft
        txtNickname.leftViewMode = UITextFieldViewMode.always
        txtNickname.snp.updateConstraints({ (make) in
            make.width.equalTo(Define.screenWidth() - 36.0)
            make.height.equalTo(44.0)
            make.centerX.equalTo(self.view)
            make.top.equalTo(lblAvatar.snp.bottom).offset(12.0)
        })
        
        let arraySex: Array = ["男","女"]
        arrayButtonSex = NSMutableArray.init(capacity: 0)
        var origin_x: CGFloat = 18.0
        for sex in arraySex {
            let itemButton = UIButton.init(type: UIButtonType.custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.setImage(UIImage.init(named: "button_choose_off"), for: UIControlState.normal)
            itemButton.setImage(UIImage.init(named: "button_choose_on"), for: UIControlState.selected)
            itemButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 0, right: 0)
            itemButton.setTitle(sex, for: UIControlState.normal)
            itemButton.titleLabel?.font = kTitleFont
            itemButton.adjustsImageWhenHighlighted = false
            itemButton.setTitleColor(Define.kColorBlack(), for: UIControlState.normal)
            itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            itemButton.addTarget(self, action: #selector(clickWithSex(sender:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(itemButton)
            arrayButtonSex.add(itemButton)
            itemButton.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 84.0, height: 40.0))
                make.left.equalTo(self.view).offset(origin_x)
                make.top.equalTo(txtNickname.snp.bottom).offset(10.0)
            })
            
            origin_x += 84.0
        }
        
        let rect_submit = CGRect.init(x: 0, y: 0, width: Define.screenWidth() - 40.0, height: 44.0)
        btnSubmit = UIButton.init(type: UIButtonType.custom)
        btnSubmit.setBackgroundImage(UIImage.imageWithDraw(Define.kColorCyanOff(), sizeMake: rect_submit), for: UIControlState.normal)
        btnSubmit.setBackgroundImage(UIImage.imageWithDraw(Define.kColorCyanOn(), sizeMake: rect_submit), for: UIControlState.highlighted)
        btnSubmit.titleLabel?.font = kButtonFont
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnSubmit.layer.cornerRadius = 4.0
        btnSubmit.layer.masksToBounds = true
        btnSubmit.setTitle("创  建", for: UIControlState.normal)
        btnSubmit.addTarget(self, action: #selector(clickWithRegister), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnSubmit)
        btnSubmit.snp.updateConstraints { (make) in
            make.size.equalTo(rect_submit.size)
            make.centerX.equalTo(self.view)
            make.top.equalTo(txtNickname.snp.bottom).offset(110.0)
        }
        
        btnAgreement = UIButton.init(type: UIButtonType.custom)
        btnAgreement.backgroundColor = UIColor.clear
        btnAgreement.titleLabel?.font = kTitleFont
        btnAgreement.addTarget(self, action: #selector(clickWithAgreement), for: UIControlEvents.touchUpInside)
        btnAgreement.setTitle("用户协议", for: UIControlState.normal)
        btnAgreement.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
        btnAgreement.setTitleColor(Define.kColorGary(), for: UIControlState.highlighted)
        self.view.addSubview(btnAgreement)
        btnAgreement.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 65.0, height: 30.0))
            make.bottom.equalTo(self.view).offset(-20.0)
            make.centerX.equalTo(self.view)
        }
    }
    
    func showIsMessage(msg: String)  {
        let alertControl = UIAlertController.init(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertControl.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func clickWithAvatar() {
        
        let sheetAvatar = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        sheetAvatar.addAction(UIAlertAction.init(title: "拍照", style: UIAlertActionStyle.default, handler: { (action) in
            self .actionSheet(buttonIndex: 1)
        }))
        sheetAvatar.addAction(UIAlertAction.init(title: "图库", style: UIAlertActionStyle.default, handler: { (action) in
            self .actionSheet(buttonIndex: 2)
        }))
        sheetAvatar.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            self .actionSheet(buttonIndex: 0)
        }))
        self.present(sheetAvatar, animated: true, completion: nil)
    }
    
    func clickWithSex(sender: UIButton)  {
        for itemButton in arrayButtonSex {
            let button = itemButton as! UIButton;
            if button == sender {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
        self.userSex = sender.title(for: UIControlState.normal)! as String
        
    }
    
    func clickWithRegister() {
        txtNickname.resignFirstResponder()
        let nickName: String = (txtNickname.text?.stringByTrimingWhitespace())!
        
        print("nickname is \(nickName)")
        
        if avatar.characters.count == 0 {
            showIsMessage(msg: "请设置头像!")
            return
        }
        
        if nickName.characters.count == 0 {
            showIsMessage(msg: "请输入昵称!")
            return
        }
        
        if userSex.characters.count == 0 {
            showIsMessage(msg: "请选择性别!")
            return
        }
        
        if mobile.characters.count == 0 {
            showIsMessage(msg: "手机号不存在!")
            return
        }
        
        HttpAPIClient.apiClientPOST("register", params: ["mobile":mobile,"icon":avatar,"nickname":nickName,"sex":userSex], success: { (result) in
            print("注册：第2步 is result:\(result)")
            
            let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.setupMainController()
            
            ChatMessage.shareChat().registerJMessage(UserManager.getUser().userId)
            
        }) { (error) in
            print("注册：第2步 is error:\(error)")
        }
    }
    
    func clickWithAgreement() {
        
    }
    
    // MARK: - UIActionSheet
    func actionSheet(buttonIndex: Int) {
        print("sheet is index:\(buttonIndex)")
        
        if buttonIndex == 0 {
            return
        }
            
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
                self.showIsMessage(msg: "该设备不支持“照相机”")
                return
            }
        } else if buttonIndex == 2 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
            } else {
                self.showIsMessage(msg: "该设备不支持“相片库”")
                return
            }
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let imageEdited: UIImage = UIImage.fixOrientation(info[UIImagePickerControllerEditedImage] as! UIImage!)
        let newImge: UIImage = UIImage.scale(imageEdited)
        
        btnAvatar.setImage(newImge, for: UIControlState.normal)
        btnAvatar.setImage(newImge, for: UIControlState.highlighted)
        
        let imageData: NSData = UIImage.dataRepresentationImage(newImge) as NSData
        
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let fullFile: String = filePath.appending("/"+UIImage.generateUuidString()+".png")
        
        print("full file is :\(fullFile)")
        let file_url = NSURL.init(string: fullFile)
        
        print("lastPathComponent is :\(file_url?.lastPathComponent)")
        
        let flag: Bool = imageData.write(toFile: fullFile, atomically: true)
        if flag {
            self.avatar = file_url?.lastPathComponent
        }
    }
    
    // MARK: -UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str_text: String = textField.text! + string
        print("_______textField: \(str_text)")
        
        if str_text.characters.count > 21 {
            return false
        }
        
        return true
    }
}
