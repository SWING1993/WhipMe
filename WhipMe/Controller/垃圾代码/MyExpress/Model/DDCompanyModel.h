//
//  DDCompanyModel.h
//  DDExpressClient
//
//  Created by yangg on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

typedef enum {
    DDCompanyModelHead = 0,
    DDCompanyModelAll
} DDCompanyModelType;

#import <Foundation/Foundation.h>

@interface DDCompanyModel : NSObject
/** 快递公司ID */
@property (nonatomic, strong) NSString *companyID;
/** 快递公司logo(由快递公司Id拼接成http路径) */
@property (nonatomic, strong) NSString *companyLogo;
/** 快递公司名字 */
@property (nonatomic, strong) NSString *companyName;
/**  选择快递公司 */
@property (nonatomic, assign) BOOL companySelect;
/** 数据model是不限还是单项数据 */
@property (nonatomic, assign) DDCompanyModelType companyModelType;


@end
