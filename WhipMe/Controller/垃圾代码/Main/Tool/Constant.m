#import <Foundation/Foundation.h>

NSString *const KSmallMoney = @"给小费（快递员会在规定时间内取件哦)";
NSString *const KTakeMessage = @"捎句话";
NSString *const KJJRTitle = @"寄件人";
NSString *const KSJRTitle = @"收件人";
NSString *const KTableArray = @"快递公司/取件时间/所寄物品/物品重量";
NSString *const KJJRInfo = @"点击添加寄件人信息";
NSString *const KSJRInfo = @"点击添加收件人信息";
NSString *const KTimeNow = @"现在";
NSString *const KWPZLTitle = @"请选择所寄物品重量\n(可用文件袋包装物品请选择文件)";
NSString *const KWPZLFile = @"文件";
NSString *const KWPZLLess = @"小于";
NSString *const KWPZLThree = @"公斤物品";
NSString *const KPhoneTake = @" 拍照";
NSString *const KPhoneChoose = @"从手机相册选择";
NSString *const KCancel = @"取消";
NSString *const KMoneyDaoFu = @"费用预估0.01元 到付";
NSString *const KMoneyYuGu = @"费用预估10-15元";
NSString *const KDaiJinQuan = @"代金券已抵5元";
NSString *const KQueDingDD = @"确定订单";
NSString *const KSmallMoneyArray = @"请选择小费金额/0元（普通件）/2元（60分钟必达件）/4元（30分钟必达件）";
NSString *const KMessageArray = @"带面单/带袋子/带箱子/带胶带/到付/已打包好/有多件/面单已填好/可拿下楼";
NSString *const KSQSJDate = @"现在/今天/明天/后天";
NSString *const KSQSJTime = @"08/09/10/11/12/13/14/15/16/17/18/19/20/21/22/23";
NSString *const KSQSJMinute = @"00/30";
NSString *const KDaoFu = @"到付";
double    const KSanFenHeight = 250;
double    const KSiFenHeight = 200;
double    const KWuFenHeight = 150;

#pragma mark - AppDeletgate

/** 预处理订单 */
NSString *const KINTERFACE_TYPE_PRE_ORDER_LIST = @"INTERFACE_TYPE_PRE_ORDER_LIST";
/** 刷新个人中心菜单的用户信息通知 */
NSString *const DDRefreshCourierUserView = @"KREFRESH_COURIER_USER_VIEW";
/** 获取个人信息通知 */
NSString *const KNOTIFICATION_USER_INFORMATION = @"NOTIFICATION_USER_INFORMATION";
/** 首页界面 等待快递员抢单窗口 的 定时器刷新通知 */
NSString *const KREFRESH_DOWN_COUNT_DOWN_VIEW = @"REFRESH_DOWN_COUNT_DOWN_VIEW";
/** 首页界面 等待快递员抢单窗口 的 删除通知 */
NSString *const KREMOVE_DOWN_COUNT_DOWN_VIEW = @"REMOVE_DOWN_COUNT_DOWN_VIEW";
/** 首页界面 等待快递员窗口 的 刷新快递员信息 */
NSString *const KREFRESH_WAIT_EXPRESS_VIEW = @"REFRESH_WAIT_EXPRESS_VIEW";
/** 首页界面 等待快递员窗口 的 隐藏窗口 */
NSString *const KREMOVE_WAIT_EXPRESS_VIEW = @"REMOVE_WAIT_EXPRESS_VIEW";
/** 首页界面 取消订单窗口 的 删除通知 */
NSString *const KREMOVE_CANCEL_ORDER_VIEW = @"REMOVE_CANCEL_ORDER_VIEW";

#pragma mark - 定义plist文件名
/** 地址搜索界面，保存旧地址搜索记录的plist */
NSString *const KIINPUT_ADDRESS_OLD_PLIST = @"DDInputAddressOld.plist";

//登录页面注册按钮名字
NSString *const DDRegisterBtnText = @"注册";
//登录页面忘记密码按钮名字
NSString *const DDForgetKeyBtnText = @"忘记密码?";
//登录界面登录按钮的文字
NSString *const DDLoginBtnText = @"登录";
//手机号的正则表达式验证
NSString *const DDMobileCheck = @"^[1][34578][0-9]{9}$";
//密码的正则表达式验证
NSString *const DDPassWordCheck = @"^[\\A-Za-z0-9\\!\\#\\$\\%\\^\\&\\*\\.\\~]{6,16}$";
//登录界面手机号的placeholder
NSString *const DDMobilePlaceHolder = @"请输入手机号";
//登录界面密码的placeholder
NSString *const DDPassWordPlaceHolder = @"请输入登录密码";
//注册界面的navigationBar标题
NSString *const DDRegistNaviTitle = @"注册";
//注册界面的提示语
NSString *const DDRemindLabelText = @"继续表示您已同意艾特小哥服务协议";
//注册界面嘟嘟快递服务协议
NSString *const DDServeAgreementBtnTitle = @"艾特小哥服务协议";
//注册界面下一步按钮title
NSString *const DDNextStepBtnTitle = @"下一步";
//注册界面验证码按钮title
NSString *const DDAuthCodeBtnTitle = @"验证码";
//注册界面验证码的placeHolder
NSString *const DDAuthCodePlaceHolder = @"请输入验证码";
//注册界面倒计时文字
NSString *const DDAfterCountDownText = @"秒后重发";

NSString *const DDDispalyName = @"艾特小哥";

/* DDPernalListHeadView arrowBtn图片**/
NSString *const  DDArrowIcon = @"";
/** 表格右滑删除的title */
NSString *const KDDTitleForDelete = @"删除";
/** 默认快递公司icon */
NSString *const KClientIcon48 = @"Client48";
NSString *const KClientIcon78 = @"Client78";

/** iconPDArraw——下一步提升“箭头” */
NSString *const KDDIconPDArraw = @"iconPDArraw";
/** 我要寄件地址cell的箭头 */
NSString *const KDDAddressArrow = @"AddressArrow";
/** 星星打分按钮图片(单个) */
NSString *const DDStarOff = @"starOff";
NSString *const DDStarOn = @"starOn";

/** 订单详情页底部的锯齿图片*/
NSString *const DDSawtooth = @"sawtooth";
/** 订单详情拨打电话图片*/
NSString *const DDOrderPhone = @"orderPhone";
/** 订单详情页抵扣卷*/
NSString *const DDDeduction = @"Deduction";
/** 订单详情页投诉图片*/
NSString *const DDComplaint = @"Complaint";
/** 查看明细的虚线图片 */
NSString *const DDCheckCostLine = @"CheckCostLine";
/** 选择／打勾的图片 */
NSString *const DDChoseIcon = @"chose";
/** 支付宝支付的图片 */
NSString *const DDAliayIcon = @"Alipay";
/** applie pay支付的图片 */
NSString *const DDApplePayIcon = @"Applepay";
/** 微信支付的图片 */
NSString *const DDWechatPayIcon = @"WechatPay";
/** 快递信息详情页的物流列表圆点图标 */
NSString *const DDLogisticsOff = @"LogisticsOff";
NSString *const DDLogisticsOn = @"LogisticsOn";
/** 修改备注的图标 */
NSString *const DDRemarksIcon = @"RemarksIcon";
/** 我的快递列表页，无数据的提示图标 */
NSString *const DDMyExpressListBG_Change = @"MyExpressListBG_Change";
NSString *const DDMyExpressListBG_Send = @"no-express";
/** 快递查询页，输入框的图标 */
NSString *const DDCallArrow = @"CallArrow";
NSString *const DDArrowRight_Gray = @"ArrowRight_Gray";
NSString *const DDCouricerQuery_CodeWhite = @"CouricerQuery_CodeWhite";
NSString *const DDCouricerQuery_CodeGreen = @"CouricerQuery_CodeGreen";
NSString *const DDCouricerQuery_CouricerIcon = @"CouricerQuery_CouricerIcon";
NSString *const DDCouricerQuery_NumberIcon = @"CouricerQuery_NumberIcon";
/** 快递列表页，导入第三方图标 */
NSString *const DDNoCourierList_Icon = @"no-express";
NSString *const DDCourierList_Bubble = @"CourierList_Bubble";
NSString *const DDCourierList_Import = @"CourierList_Import";
NSString *const DDCourierList_JDIcon = @"CourierList_JDIcon";
NSString *const DDCourierList_SuIcon = @"CourierList_SuIcon";
NSString *const DDCourierList_Taobao = @"CourierList_Taobao";
/** 扫一扫界面的扫码框、线条、二维码、条形码 */
NSString *const DDZbar_Frame = @"Zbar_Frame";
NSString *const DDZbar_LineRow = @"Zbar_LineRow";
NSString *const DDZbar_EAN13Code = @"Zbar_EAN13Code";
NSString *const DDZbar_QRCode = @"Zbar_QRCode";
NSString *const DDZbar_Editing = @"DDZbar_Editing";
/** 界面返回的图片 */
NSString *const DDBackGreenBarIcon = @"back";
NSString *const DDBackWhiteBarIcon = @"Back_White";
/** 个人中心－头像默认图 */
NSString *const DDPersonalHeadIcon = @"PersonalHead";
/** 身份认真 顶部警告的icon */
NSString *const DDAssureIcon = @"AssureIcon";
/** 身份认真 默认身份证正面照icon */
NSString *const DDPersonalIdCard = @"PersonalIdCard";
NSString *const DDDefaultIdCard = @"DefaultIdCard";
/** 身份认真 默认手持身份证肖像icon */
NSString *const DDPersonalPortrait = @"PersonalPortrait";
NSString *const DDDefaultIdPortrait = @"DefaultIdPortrait";
/** 地址搜索界面 */
NSString *const DDOldAddressClock = @"Clock";
NSString *const DDInputAddressMap = @"Pin";
/** 首页地址搜索mapicon */
NSString *const DDHomeSearchMapIcon = @"HomeSearchMap";
/** 首页导航栏左边个人中心icon */
NSString *const DDHomePersonalIcon = @"HomePersonal";
/** 首页取消订单消息窗额icon */
NSString *const DDCancelOrderTitleIcon = @"cancelAlertImage";
/** 我要寄件地址cell的收件／寄件icon */
NSString *const KDDAddressSendIcon = @"send";
NSString *const KDDAddressReciveIcon = @"recive";
/** 我要寄件 费用预估 抵扣卷icon */
NSString *const KDDDeductionIcon = @"deduction";
/** 我要寄件 费用预估 小费icon */
NSString *const KDDTipPriceIcon = @"TipPrice";
/** 我要寄件 费用预估 捎句话icon */
NSString *const KDDTakeWordsIcon = @"TakeWords";


