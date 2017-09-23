//
//  DDCompanyModel.h
//  DDExpressClient
//
//  Created by EWPSxx on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCompanyModel : NSObject

@property (nonatomic, copy) NSString                                    *companyID;                                     /**< 快递公司ID */
@property (nonatomic, copy) NSString                                    *companyName;                                   /**< 快递公司名字 */
@property (nonatomic, copy) NSString                                    *companyLogo;                                   /**< 快递公司logo */

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)companyWithDict: (NSDictionary *)dict;

@end
