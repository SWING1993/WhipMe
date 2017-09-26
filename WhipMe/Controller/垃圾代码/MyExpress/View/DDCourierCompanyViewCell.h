//
//  DDCourierCompanyViewCell.h
//  DDExpressClient
//
//  Created by yangg on 16/3/8.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
 cell的高度
 */
#define DDCC_CELL_HEADER 40.0f
#define DDCC_CELL_HEIGHT 60.0f


#import <UIKit/UIKit.h>
#import "DDCompanyModel.h"

@interface DDCourierCompanyViewCell : UITableViewCell

/** 分界线 */
@property (nonatomic, strong) UILabel *lblLine;
/** cell的数据Model */
@property (nonatomic, strong) DDCompanyModel *cellForCompany;

@end
