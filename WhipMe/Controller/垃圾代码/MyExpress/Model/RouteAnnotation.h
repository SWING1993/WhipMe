//
//  RouteAnnotation.h
//  DDExpressClient
//
//  Created by yangg on 16/3/11.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
    
}
/** <0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 */
@property (nonatomic) int type;
@property (nonatomic) int degree;

@end
