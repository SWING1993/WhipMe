//
//  WMLoginWayController.m
//  WhipMe
//
//  Created by anve on 17/1/24.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMLoginWayController.h"

@interface WMLoginWayController ()

@end

@implementation WMLoginWayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    
    UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginBackground"]];
    imageBG.backgroundColor = [UIColor clearColor];
    imageBG.contentMode = UIViewContentModeScaleAspectFill;
    imageBG.clipsToBounds = YES;
    [self.view addSubview:imageBG];
    [imageBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_app"]];
    imageLogo.backgroundColor = [UIColor clearColor];
    imageLogo.contentMode = UIViewContentModeScaleAspectFill;
    imageLogo.clipsToBounds = YES;
    [self.view addSubview:imageLogo];
    [imageLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(152/2.0, 152/2.0));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(80.0);
    }];
    
    UIImageView *image_btw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btw_name"]];
    image_btw.backgroundColor = [UIColor clearColor];
    image_btw.contentMode = UIViewContentModeScaleAspectFill;
    image_btw.clipsToBounds = YES;
    [self.view addSubview:image_btw];
    [image_btw mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(123/2.0, 36/2.0));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(168.0);
    }];

    UILabel *lblMessage = [[UILabel alloc] init];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    [lblMessage setTextAlignment:NSTextAlignmentLeft];
    [lblMessage setTextColor:[Define kColorLight]];
    [lblMessage setFont:[UIFont systemFontOfSize:12.0]];
    [lblMessage setNumberOfLines:0];
    [self.view addSubview:lblMessage];
    NSString *str_msg = @"先定一个能达到的";
    NSDictionary *attribute = @{NSFontAttributeName:lblMessage.font, NSForegroundColorAttributeName:lblMessage.textColor};
    CGSize size_h_msg = [str_msg boundingRectWithSize:CGSizeMake(16.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    NSMutableAttributedString *att_msg = [[NSMutableAttributedString alloc] initWithString:str_msg attributes:attribute];
    [lblMessage setAttributedText:att_msg];
    [lblMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0, floorf(size_h_msg.height+1.0)));
        make.centerX.equalTo(weakSelf.view).offset(-8.0);
        make.top.equalTo(image_btw.mas_bottom).offset(30.0);
    }];
    
    UILabel *lblMessage2 = [[UILabel alloc] init];
    [lblMessage2 setBackgroundColor:[UIColor yellowColor]];
    [lblMessage2 setTextAlignment:NSTextAlignmentLeft];
    [lblMessage2 setTextColor:[Define kColorRed]];
    [lblMessage2 setFont:[UIFont boldSystemFontOfSize:16.0]];
    [lblMessage2 setNumberOfLines:0];
    [self.view addSubview:lblMessage2];
    NSString *str_msg2 = @"小目标\n.\n.\n.";
    NSDictionary *attribute2 = @{NSFontAttributeName:lblMessage2.font, NSForegroundColorAttributeName:lblMessage2.textColor};
    NSMutableAttributedString *att_msg2 = [[NSMutableAttributedString alloc] initWithString:str_msg2 attributes:attribute2];
    [lblMessage2 setAttributedText:att_msg2];
    [lblMessage2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0, 90.0));
        make.left.equalTo(lblMessage.mas_right);
        make.top.equalTo(lblMessage.mas_bottom).offset(-20.0);
    }];
    
//    let viewButton = UIView.init()
//    viewButton.backgroundColor = UIColor.clear
//    self.view.addSubview(viewButton)
//    viewButton.snp.updateConstraints { (make) in
//        make.left.right.equalTo(self.view)
//        make.height.equalTo(self.view).offset(-size_h)
//        make.top.equalTo(self.view).offset(size_h)
//    }
//    
//    let arrayImageOff: Array = ["button_phone_off","button_weixin_off","button_create_off"]
//    let arrayImageOn: Array  = ["button_phone_on","button_weixin_on","button_create_on"]
//    let arrayTitle: Array = ["手机登录","微信登录","创建账号"]
//    var origin_y: CGFloat = 0.0
//    
//    for i in 0..<arrayTitle.count {
//        
//        let strTitle: String = arrayTitle[i]
//        let strImageOff: String = arrayImageOff[i]
//        let strImageOn: String = arrayImageOn[i]
//        
//        let itemButton: UIButton = UIButton.init(type: UIButtonType.custom)
//        itemButton.backgroundColor = UIColor.clear
//        itemButton.titleLabel?.font = kTitleFont
//        itemButton.titleEdgeInsets = UIEdgeInsets.init(top: 55.0, left: -45.0, bottom: 0, right: 0)
//        itemButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 20.0, right: 0)
//        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
//        itemButton.contentVerticalAlignment = UIControlContentVerticalAlignment.top
//        itemButton.setImage(UIImage.init(named: strImageOff), for: UIControlState.normal)
//        itemButton.setImage(UIImage.init(named: strImageOn), for: UIControlState.highlighted)
//        itemButton.setTitleColor(Define.kColorGray(), for: UIControlState.normal)
//        itemButton.setTitleColor(Define.kColorGary(), for: UIControlState.highlighted)
//        itemButton.setTitle(strTitle, for: UIControlState.normal)
//        itemButton.tag = i+button_index;
//        itemButton.addTarget(self, action: #selector(clickWithItem(sender:)), for: UIControlEvents.touchUpInside)
//        viewButton.addSubview(itemButton)
//        itemButton.snp.updateConstraints({ (make) in
//            make.size.equalTo(CGSize.init(width: 65.0, height: 65.0))
//            make.top.equalTo(origin_y)
//            make.centerX.equalTo(viewButton)
//        })
//        
//        origin_y += 93.0
//    }
//    
   

}

@end
