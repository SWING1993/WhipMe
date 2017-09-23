#import <Foundation/Foundation.h>
#import "DDNavigationController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewResource.h"
#import "DDAlertView.h"

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define ATXIAOGEAPPID @"1099105951"

#define DDRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DDRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DDRandColor DDRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define DDSCreenBounds [UIScreen mainScreen].bounds

#define DD_DocumentFolder() [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DD_DocumentFilePath(fullPath) [DD_DocumentFolder() stringByAppendingPathComponent:fullPath]

#define isIos7      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define StatusbarSize ((isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()

#define DDMainBundle(listName) [[NSBundle mainBundle] pathForResource:listName ofType:nil]
/** 通知处理 */
#define DDAddNotification(_selector,_name)\
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])

#define DDRemoveNotificationWithName(_name)\
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])

#define DDRemoveNotificationObserver() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#define DDPostNotification(_name)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])

#define DDPostNotificationWithObj(_name,_obj)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:nil])

#define DDPostNotificationWithInfos(_name,_obj,_infos)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:_infos])

#define DDInterfaceSuccess [[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"200"]
//-----------------------------------------------------
/*
 编写人员：杨刚
 用意：字符大小的统一调用
 */

#define KCountFont [UIFont systemFontOfSize:10.0f]
#define kTimeFont [UIFont systemFontOfSize:12.0f]
#define kTitleFont [UIFont systemFontOfSize:14.0f]
#define kContentFont [UIFont systemFontOfSize:16.0f]
#define kButtonFont [UIFont systemFontOfSize:18.0f]

//字符的颜色
#define TIME_COLOR DDRGBColor(153, 153, 153)
#define CONTENT_COLOR DDRGBColor(102, 102, 102)
#define TITLE_COLOR DDRGBColor(51, 51, 51)
#define BARBUTTON_COLOR DDRGBColor(53, 53, 53)

#define KPlaceholderColor DDRGBColor(188, 188, 188)

//一些视图（按钮，线条）的颜色
#define BORDER_COLOR DDRGBColor(233, 233, 233)
#define HIGHLIGHT_COLOR DDRGBColor(215, 215, 215)
#define KBackground_COLOR DDRGBColor(238, 238, 238)
#define WHITE_COLOR DDRGBColor(255,255,255)
#define KShadowImage_Color DDRGBColor(210, 210, 210)

//绿颜色的色值
#define DDGreen_Color DDRGBColor(32, 198, 122)
//红颜色的色值
#define DDRed_Color DDRGBColor(255, 91, 17)
//橙颜色的色值
#define DDOrange_Color DDRGBColor(255, 173, 74)
//浅橙色的色值
#define DDAssure_Color DDRGBColor(255, 240, 227)

//4-13 Added
#define RED_COLOR DDRGBColor(252, 91, 83)
#define REDON_COLOR DDRGBColor(224, 82, 74)
#define REDFALSE_COLOR DDRGBColor(252, 178, 175)

#define MainScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define MainScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define LocalUserInfo [UserDefaults objectForKey:@"localUserInfo"]

#define kURL_Pre_Test @"http://share.atxiaoge.com"
#define kURL_Pre_Test1 @"http://res.atxiaoge.com"

#define DEVICE_IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height == 480.f)
#define DEVICE_IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height == 568.f)
#define DEVICE_IS_IPHONE6 ([UIScreen mainScreen].bounds.size.height == 667.f)
#define DEVICE_IS_IPHONE6PLUS ([UIScreen mainScreen].bounds.size.height == 736.f)

//web View URL
#define CouponRuleHtmlUrlStr [NSString stringWithFormat:@"%@/res/links/FAQ_youhui.html",kURL_Pre_Test1]              //优惠券规则

#define BalanceMoneyRuleHtmlUrlStr [NSString stringWithFormat:@"%@/res/links/FAQ_zhifu.html",kURL_Pre_Test1]              //余额规则
#define PopularizeHtmlUrlStr [NSString stringWithFormat:@"%@/atxg/register_award/entrance?",kURL_Pre_Test]             //推广活动
#define ServiceTermsHtmlUrlStr @"http://res.atxiaoge.com/res/links/agreement.html"              //服务条款
#define XiaogeServiceHtmlUrlStr @"http://res.atxiaoge.com/res/links/legal_notices.html"             //艾特小哥服务协议
#define EstimateMoneyHtmlUrlStr @"http://res.atxiaoge.com/res/links/price_rule.html"             //预估费用
#define ExchangeRuleUrlStr @"http://res.atxiaoge.com/res/links/FAQ_duihuan.html"        //兑换规则


#define OrderShareImageURL @"http://res.atxiaoge.com/res/imgs/share01.jpg"
#define RecommendShareImageURL @"http://res.atxiaoge.com/res/imgs/logo_100x100.png"

//项目的名字
extern NSString *const DDDispalyName;

extern NSString *const DDRegisterBtnText;

extern NSString *const DDForgetKeyBtnText;

extern NSString *const DDLoginBtnText;

extern NSString *const DDMobileCheck;

extern NSString *const DDPassWordCheck;

extern NSString *const DDMobilePlaceHolder;

extern NSString *const DDPassWordPlaceHolder;

extern NSString *const DDRegistNaviTitle;

extern NSString *const DDServeAgreementBtnTitle;

extern NSString *const DDNextStepBtnTitle;

extern NSString *const DDAuthCodeBtnTitle;

extern NSString *const DDAuthCodePlaceHolder;

extern NSString *const DDRemindLabelText;

extern NSString *const DDAfterCountDownText;

extern NSString *const DDArrowIcon;

/** 星星打分按钮图片(单个) */
extern NSString *const DDStarOff;
extern NSString *const DDStarOn;
/** 订单详情页底部的锯齿图片*/
extern NSString *const DDSawtooth;
/** 订单详情拨打电话图片*/
extern NSString *const DDOrderPhone;
/** 订单详情页抵扣卷Deduction*/
extern NSString *const DDDeduction;
/** 订单详情页投诉图片*/
extern NSString *const DDComplaint;
/** 查看明细的虚线图片 */
extern NSString *const DDCheckCostLine;
/** 选择／打勾的图片 */
extern NSString *const DDChoseIcon;
/** 支付宝支付的图片 */
extern NSString *const DDAliayIcon;
/** applie pay支付的图片 */
extern NSString *const DDApplePayIcon;
/** 微信支付的图片 */
extern NSString *const DDWechatPayIcon;
/** 快递信息详情页的物流列表圆点图标 */
extern NSString *const DDLogisticsOff;
extern NSString *const DDLogisticsOn;
/** 修改备注的图标 */
extern NSString *const DDRemarksIcon;
/** 我的快递列表页，无数据的提示图标 */
extern NSString *const DDMyExpressListBG_Change;
extern NSString *const DDMyExpressListBG_Send;
/** 快递查询页，输入框的图标 */
extern NSString *const DDCallArrow;
extern NSString *const DDArrowRight_Gray;
extern NSString *const DDCouricerQuery_CodeWhite;
extern NSString *const DDCouricerQuery_CodeGreen;
extern NSString *const DDCouricerQuery_CouricerIcon;
extern NSString *const DDCouricerQuery_NumberIcon;
/** 快递列表页，导入第三方图标 */
extern NSString *const DDNoCourierList_Icon;
extern NSString *const DDCourierList_Bubble;
extern NSString *const DDCourierList_Import;
extern NSString *const DDCourierList_JDIcon;
extern NSString *const DDCourierList_SuIcon;
extern NSString *const DDCourierList_Taobao;
/** 扫一扫界面的扫码框、线条、二维码、条形码 */
extern NSString *const DDZbar_Frame;
extern NSString *const DDZbar_LineRow;
extern NSString *const DDZbar_EAN13Code;
extern NSString *const DDZbar_QRCode;
extern NSString *const DDZbar_Editing;
/** 界面返回的图片 */
extern NSString *const DDBackGreenBarIcon;
extern NSString *const DDBackWhiteBarIcon;
/** 个人中心－头像默认图 */
extern NSString *const DDPersonalHeadIcon;
/** 身份认真 顶部警告的icon */
extern NSString *const DDAssureIcon;
/** 身份认真 默认身份证正面照icon */
extern NSString *const DDPersonalIdCard;
extern NSString *const DDDefaultIdCard;
/** 身份认真 默认手持身份证肖像icon */
extern NSString *const DDPersonalPortrait;
extern NSString *const DDDefaultIdPortrait;
/** 地址搜索界面 */
extern NSString *const DDOldAddressClock;
extern NSString *const DDInputAddressMap;
/** 首页地址搜索mapicon */
extern NSString *const DDHomeSearchMapIcon;
/** 首页导航栏左边个人中心icon */
extern NSString *const DDHomePersonalIcon;
/** 首页取消订单消息窗额icon */
extern NSString *const DDCancelOrderTitleIcon;
/** 我要寄件地址cell的收件／寄件icon */
extern NSString *const KDDAddressSendIcon;
extern NSString *const KDDAddressReciveIcon;
/** 我要寄件 费用预估 抵扣卷icon */
extern NSString *const KDDDeductionIcon;
/** 我要寄件 费用预估 小费icon */
extern NSString *const KDDTipPriceIcon;
/** 我要寄件 费用预估 捎句话icon */
extern NSString *const KDDTakeWordsIcon;
/** iconPDArraw——下一步提升“箭头” */
extern NSString *const KDDIconPDArraw;
/** 我要寄件地址cell的箭头 */
extern NSString *const KDDAddressArrow;
/** 表格右滑删除的title */
extern NSString *const KDDTitleForDelete;
/** 默认快递公司icon */
extern NSString *const KClientIcon48;
extern NSString *const KClientIcon78;

/** 预处理订单 */
extern NSString *const KINTERFACE_TYPE_PRE_ORDER_LIST;
/** 刷新个人中心菜单的用户信息通知 */
extern NSString *const DDRefreshCourierUserView;
///** 获取个人信息通知 */
extern NSString *const KNOTIFICATION_USER_INFORMATION;
/** 首页界面 等待快递员抢单窗口 的 定时器刷新通知 */
extern NSString *const KREFRESH_DOWN_COUNT_DOWN_VIEW;
/** 首页界面 等待快递员抢单窗口 的 删除通知 */
extern NSString *const KREMOVE_DOWN_COUNT_DOWN_VIEW;
/** 首页界面 等待快递员窗口 的 刷新快递员信息 */
extern NSString *const KREFRESH_WAIT_EXPRESS_VIEW;
/** 首页界面 等待快递员窗口 的 隐藏窗口 */
extern NSString *const KREMOVE_WAIT_EXPRESS_VIEW;
/** 首页界面 取消订单窗口 的 删除通知 */
extern NSString *const KREMOVE_CANCEL_ORDER_VIEW;

#pragma mark - 定义plist文件名
/** 地址搜索界面，保存旧地址搜索记录的plist */
extern NSString *const KIINPUT_ADDRESS_OLD_PLIST;

//基本的一个间隙距离
#define kMargin 10.0f

//导航条的默认高度
#define KNavHeight 64.0f

//Cell的默认高度
#define KCellHeightForRow 44.0f

//表格Header的默认高度
#define KCellHeaderForSection 20.0f

#define DDLeftSliderMenuScale 0.70        /** 侧边菜单栏的宽度 */

//视图的中点/中线
#define VIEW_CENTER self.view.center
#define VIEW_CENTER_X self.view.center.x
#define VIEW_CENTER_Y self.view.center.y

//屏幕边界
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

//-----------------------------------------------------=======
//-----------------------------------------------------
//-----------------------------------------------------
/*
 编写人员：宋刚
 用意：定义常量
 */
extern NSString *const KSmallMoney;
extern NSString *const KTakeMessage;
extern NSString *const KJJRTitle;
extern NSString *const KSJRTitle;
extern NSString *const KTableArray;
extern NSString *const KJJRInfo;
extern NSString *const KSJRInfo;
extern NSString *const KTimeNow;
extern NSString *const KWPZLTitle;
extern NSString *const KWPZLFile;
extern NSString *const KWPZLLess;
extern NSString *const KWPZLThree;
extern NSString *const KPhoneTake;
extern NSString *const KPhoneChoose;
extern NSString *const KCancel;
extern NSString *const KMoneyDaoFu;
extern NSString *const KMoneyYuGu;
extern NSString *const KDaiJinQuan;
extern NSString *const KQueDingDD;
extern NSString *const KSmallMoneyArray;
extern NSString *const KMessageArray;
extern NSString *const KSQSJDate;
extern NSString *const KSQSJTime;
extern NSString *const KSQSJMinute;
extern NSString *const KDaoFu;
extern double   const KSanFenHeight;
extern double   const KSiFenHeight;
extern double   const KWuFenHeight;


//-----------------------------------------------------

//个人中心菜单宽度
#define DDPersonalListMenuWidth [UIScreen mainScreen].bounds.size.width - 120
//个人中心菜单弹出动画时间
#define DDPersonalLsitDuration 1.0