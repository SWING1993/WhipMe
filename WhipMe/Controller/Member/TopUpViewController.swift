//
//  TopUpViewController.swift
//  WhipMe
//
//  Created by yangg on 2016/10/5.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class TopUpViewController: UIViewController, UITextFieldDelegate {

    private var textMoney: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "充值"
        self.view.backgroundColor = Define.kColorBackGround()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        let viewCurrent = UIView.init()
        viewCurrent.backgroundColor = UIColor.white
        viewCurrent.layer.cornerRadius = 4.0
        viewCurrent.layer.masksToBounds = true
        self.view.addSubview(viewCurrent)
        viewCurrent.snp.updateConstraints { (make) in
            make.left.top.equalTo(10.0)
            make.right.equalTo(-10.0)
            make.height.equalTo(290.0)
        }
        
        let lblMoneyTitle = UILabel.init()
        lblMoneyTitle.backgroundColor = UIColor.clear
        lblMoneyTitle.textAlignment = NSTextAlignment.left;
        lblMoneyTitle.textColor = Define.kColorGray()
        lblMoneyTitle.font = KContentFont
        lblMoneyTitle.text = "充值金额"
        viewCurrent.addSubview(lblMoneyTitle)
        lblMoneyTitle.snp.updateConstraints { (make) in
            make.height.equalTo(40.0)
            make.width.equalTo(viewCurrent).offset(-60.0)
            make.left.equalTo(30.0)
            make.top.equalTo(viewCurrent)
        }
        
        textMoney = UITextField.init()
        textMoney.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textMoney.backgroundColor = UIColor.clear
        textMoney.textAlignment = NSTextAlignment.left
        textMoney.font = UIFont.systemFont(ofSize: 22.0)
        textMoney.keyboardType = UIKeyboardType.decimalPad
        textMoney.textColor = Define.kColorBlack()
        textMoney.delegate = self
        textMoney.placeholder = "请输入充值金额"
//        textMoney.attributedPlaceholder = NSMutableAttributedString.init(string: "请输入充值金额", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20.0), NSForegroundColorAttributeName:Define.kColorGray()])
        viewCurrent.addSubview(textMoney)
        textMoney.snp.makeConstraints { (make) in
            make.height.equalTo(50.0)
            make.width.equalTo(lblMoneyTitle.snp.width)
            make.left.equalTo(lblMoneyTitle.snp.left)
            make.top.equalTo(lblMoneyTitle.snp.bottom)
        }
        
        let leftView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40.0, height: 50.0))
        leftView.textAlignment = NSTextAlignment.center
        leftView.textColor = Define.kColorBlack()
        leftView.font = UIFont.systemFont(ofSize: 22.0)
        leftView.text = "¥"
        textMoney.leftView = leftView
        textMoney.leftViewMode = UITextFieldViewMode.always
        
        let lineView = UIView.init()
        lineView.backgroundColor = Define.kColorLine()
        viewCurrent.addSubview(lineView)
        lineView.snp.updateConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalTo(viewCurrent)
            make.top.equalTo(textMoney.snp.bottom).offset(-0.5)
        }
        
        let btnWechat = UIButton.init(type: UIButtonType.custom)
        btnWechat.backgroundColor = UIColor.clear
        btnWechat.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btnWechat.titleLabel?.font = KContentFont
        btnWechat.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
        btnWechat.adjustsImageWhenHighlighted = false
        btnWechat.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 18.0, bottom: 0, right: 0)
        btnWechat.setTitle("微信支付", for: UIControlState.normal)
        btnWechat.setImage(UIImage.init(named: "choose_btn"), for: UIControlState.normal)
        viewCurrent.addSubview(btnWechat)
        btnWechat.snp.updateConstraints { (make) in
            make.left.equalTo(35.0)
            make.top.equalTo(textMoney.snp.bottom).offset(30.0)
            make.width.equalTo(viewCurrent).offset(-70.0)
            make.height.equalTo(20.0)
        }
        
        let rect_submit = CGRect.init(x: 0, y: 0, width: Define.screenWidth() - 70.0, height: 44.0)
        let btnSubmit = UIButton.init(type: UIButtonType.custom)
        btnSubmit.setBackgroundImage(UIImage.imageWithDraw(Define.kColorCyanOff(), sizeMake: rect_submit), for: UIControlState.normal)
        btnSubmit.setBackgroundImage(UIImage.imageWithDraw(Define.kColorCyanOn(), sizeMake: rect_submit), for: UIControlState.highlighted)
        btnSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnSubmit.layer.cornerRadius = 22.0
        btnSubmit.layer.masksToBounds = true
        btnSubmit.setTitle("去充值", for: UIControlState.normal)
        btnSubmit.addTarget(self, action: #selector(clickWithSubmit), for: UIControlEvents.touchUpInside)
        viewCurrent.addSubview(btnSubmit)
        btnSubmit.snp.makeConstraints { (make) in
            make.size.equalTo(rect_submit.size)
            make.centerX.equalTo(self.view)
            make.top.equalTo(btnWechat.snp.bottom).offset(40.0)
        }
        
    }
    
    func clickWithSubmit() {
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let string_ns = textField.text as NSString?
        let string_temp = string_ns?.replacingCharacters(in: range, with: string)
        if string_temp?.characters.count == 0 {
            return true
        }
        
        let string_float:Float = Float(string_temp!)!
        print("text delegate is string_float:\(string_float)")
        
        if string_float > 5000.0 {
            textField.text = "5000"
            return false
        }
        
        
        
//        if (textField.tag == KTextTag)
//        {
//            NSString *tempText = [NSString stringWithFormat:@"%@%@",textField.text, string];
//            tempText = [tempText stringByReplacingCharactersInRange:range withString:@""];
//            NSArray *arrayCount = [tempText componentsSeparatedByString:@"."];
//            
//            if (arrayCount.count > 2)
//            {
//                return false;
//            } else if ([tempText floatValue] > _paidMoney) {
//                [self showisMessage:[NSString stringWithFormat:@"您的消费金额不能大于%.2f元！",_paidMoney]];
//                return false;
//            } else if ([tempText rangeOfString:@"."].location != NSNotFound) {
//                //只能有两位小数
//                NSRange tempRange = [tempText rangeOfString:@"."];
//                if (tempText.length - tempRange.location - tempRange.length > 2)
//                {
//                    return false;
//                }
//            }
//        }
        
        
        return true
    }
    
  

}
