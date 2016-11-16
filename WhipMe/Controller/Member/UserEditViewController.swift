//
//  UserEditViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/22.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

public enum EditControlType {
    case note
    case nickname
    case signature
}

class UserEditViewController: UIViewController {
    
    var txtField: UITextField!
    var txtView: UITextView!
    var textEditedBlock: ((String, EditControlType) -> Void)?
    
    public var editControl: EditControlType?
    public var strPlaceholder: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (editControl == nil) {
            editControl = EditControlType.nickname
        }
        self.navigationItem.title = controlTitle(editType: editControl!)
        self.view.backgroundColor = kColorBackGround
        
        let rightBarItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.done, target: self, action: #selector(clickWithSave))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        if editControl == EditControlType.nickname {
            setupField()
        } else if editControl == EditControlType.signature {
            setupTextView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupField() {
        
        txtField = UITextField.init()
        txtField.backgroundColor = UIColor.white
        txtField.font = kContentFont
        txtField.textColor = kColorBlack
        txtField.text = strPlaceholder ?? ""
        txtField.textAlignment = NSTextAlignment.left
        txtField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        txtField.clearButtonMode = UITextFieldViewMode.whileEditing
        self.view.addSubview(txtField)
        txtField.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(30.0)
            make.height.equalTo(50.0)
        }
        
        let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 0))
        viewLeft.backgroundColor = UIColor.clear
        txtField.leftView = viewLeft
        txtField.leftViewMode = UITextFieldViewMode.always
        
        let viewLine1: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 0.5))
        viewLine1.backgroundColor = kColorLine
        txtField.addSubview(viewLine1)
        
        let viewLine2: UIView = UIView.init()
        viewLine2.backgroundColor = kColorLine
        txtField.addSubview(viewLine2)
        viewLine2.snp.updateConstraints { (make) in
            make.left.right.equalTo(txtField)
            make.bottom.equalTo(txtField)
            make.height.equalTo(0.5)
        }
        
    }
    
    func setupTextView() {
        
        let viewTemp = UIView.init()
        viewTemp.backgroundColor = UIColor.white
        self.view.addSubview(viewTemp)
        viewTemp.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(30.0)
            make.height.equalTo(82.0)
        }
        
        txtView = UITextView.init()
        txtView.backgroundColor = UIColor.white
        txtView.font = kContentFont
        txtView.textColor = kColorBlack
        txtView.textAlignment = NSTextAlignment.left
        txtView.text = strPlaceholder ?? ""
        viewTemp.addSubview(txtView)
        txtView.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(1.0)
            make.height.equalTo(80.0)
        }
        
        let viewLine1: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 0.5))
        viewLine1.backgroundColor = kColorLine
        viewTemp.addSubview(viewLine1)
        
        let viewLine2: UIView = UIView.init()
        viewLine2.backgroundColor = kColorLine
        viewTemp.addSubview(viewLine2)
        viewLine2.snp.updateConstraints { (make) in
            make.left.right.equalTo(viewTemp)
            make.bottom.equalTo(viewTemp)
            make.height.equalTo(0.5)
        }
        
    }
    
    func controlTitle(editType: EditControlType) -> String {
        switch editType {
        case .nickname:
            return "昵称"
        case .signature:
            return "签名"
        default:
            return "昵称1"
        }
    }
    
    func clickWithSave() {
        print(self.classForCoder)
        if (editControl == nil) {
            editControl = EditControlType.nickname
        }
        var strEdited: String!
        if editControl == EditControlType.nickname {
            strEdited = txtField.text
            if txtField.text?.characters.count == 0 {
                return
            }
        }
        if editControl == EditControlType.signature {
            strEdited = txtView.text
            if txtView.text?.characters.count == 0 {
                return
            }
        }
        
        if self.textEditedBlock != nil {
            self.textEditedBlock!(strEdited!, editControl!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    // MARK: - 

}
