//
//  XYOrderDetailViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderDetailViewController.h"
#import "XYOrderDetailViewModel.h"
#import "XYOrderListManager.h"

#import "XYASearchRouteViewController.h"
#import "XYTargetLocationViewController.h"
#import "XYASelectMapLocViewController.h"
#import "XYSelectDeviceTypeViewController.h"
#import "XYSelectPlanViewController.h"
#import "XYCancelOrderViewController.h"
#import "XYRepairDetailViewController.h"
#import "XYRepairSelectionsViewController.h"

#import "XYCustomButton.h"
#import "XYOrderDetailButtonsView.h"
#import "XYCommentCell.h"

#import "XYEditSelectCell.h"
#import "XYOrderDetailTopCell.h"
#import "SimpleAlignCell.h"
#import "SimpleEditCell.h"
#import "XYQRCodeCell.h"
#import "XYRepairOrderPhotoCell.h"
#import "XYVerifyCodeCell.h"
#import "XYMeizuOrderPhotoCell.h"
#import "XYOtherFaultsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIAlertView+Blocks.h"
#import "XYPayUtil.h"
#import "XYGuaranteeStatusCell.h"
#import "XYFaultTagsCell.h"
#import "XYPlatformFeeBarView.h"
#import "Masonry.h"
#import "XYPlatformFeeCell.h"
#import "XYCompressImageuUtil.h"
#import "HttpCache.h"

typedef NS_ENUM(NSInteger, XYOrderDetailActionSheet) {
    XYOrderDetailActionSheetPay = 1,    // 支付（微信支付宝）
    XYOrderDetailActionSheetPhoto = 2,    // 拍照（相机相册）
};

@interface XYOrderDetailViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate, XYOrderDetailCallBackDelegate,SimpleEditCellDelegate,XYQRCodeCellDelegate,XYSelectRepairingPlanDelegate,XYRepairOrderPhotoCellDelegate,XYMeizuOrderPhotoCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,XYGuaranteeStatusDelegate,XYSelectDeviceTypeDelegate,XYFaultTagsCellDelegate>
//view
@property(strong,nonatomic) UIRefreshControl* refreshControl;
@property(strong,nonatomic) UITableView* tableView;
@property(strong,nonatomic) XYQRCodeCell* qrCell;//收款码
@property(strong,nonatomic) XYRepairOrderPhotoCell* photoCell;//序列号照片
@property(strong,nonatomic) XYMeizuOrderPhotoCell* meizuPhotoCell;//魅族照片
@property(strong,nonatomic) XYOrderDetailButtonsView* buttonView;//底部按钮
@property(strong,nonatomic) XYPlatformFeeBarView* platformFeeBarView;//底部按钮
@property(assign,nonatomic) BOOL isKeyboardVisible;
//data
@property(strong,nonatomic) NSString* orderId;
@property(assign,nonatomic) XYBrandType bid;
@property(strong,nonatomic) XYOrderDetailViewModel* viewModel;
@property(strong,nonatomic) XYPayUtil* payUtil;
@property(strong,nonatomic) XYRepairDetailViewController* selectionController;

@end

@implementation XYOrderDetailViewController

- (id)initWithOrderId:(NSString *)orderId brand:(XYBrandType)type{
    if (self = [super init]){
        _orderId = [orderId copy];
        _bid = type;
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onWechatPaid:)  name:XY_NOTIFICATION_WECHAT_SDK_PAID object:nil];
        _isKeyboardVisible = NO;
    }
    return self;
}

- (void)dealloc{
    self.viewModel.delegate = nil;
    [self.viewModel cancelAllRequests];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_WECHAT_SDK_PAID object:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //第一次加载页面
    [self loadOrderDetail];//1.请求订单详情
    [self loadCachedImages];//2.获取本地缓存照片
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    switch (self.viewModel) {
//        case <#constant#>:
//            <#statements#>
//            break;
//            
//        default:
//            break;
//    }
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYOrderDetailViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"订单详情";
    [self shouldShowBackButton:true];
    self.view.backgroundColor = XY_COLOR(246, 248, 251);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buttonView];
    self.tableView.hidden = true;
    [self initPlatformFeeBarView];
}

#pragma mark - property

- (UIRefreshControl*)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(loadOrderDetail) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView =  [XYWidgetUtil getSimpleTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - 60)];
        _tableView.backgroundColor = XY_COLOR(246, 248, 251);
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        [_tableView addSubview:self.refreshControl];
        [_tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
        [XYOrderDetailTopCell xy_registerTableView:_tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
        [SimpleAlignCell xy_registerTableView:_tableView identifier:[SimpleAlignCell defaultReuseId]];
        [SimpleEditCell xy_registerTableView:_tableView identifier:[SimpleEditCell defaultReuseId]];
        [XYEditSelectCell xy_registerTableView:_tableView identifier:[XYEditSelectCell defaultReuseId]];
        [XYCommentCell xy_registerTableView:_tableView identifier:[XYCommentCell defaultReuseId]];
        [XYOtherFaultsCell xy_registerTableView:_tableView identifier:[XYOtherFaultsCell defaultReuseId]];
        [XYGuaranteeStatusCell xy_registerTableView:_tableView identifier:[XYGuaranteeStatusCell defaultReuseId]];
        [XYFaultTagsCell xy_registerTableView:_tableView identifier:[XYFaultTagsCell defaultReuseId]];
        [XYVerifyCodeCell xy_registerTableView:_tableView identifier:[XYVerifyCodeCell defaultReustId]];
        [XYRepairOrderPhotoCell xy_registerTableView:_tableView identifier:[XYRepairOrderPhotoCell defaultReuseId]];
        [XYMeizuOrderPhotoCell xy_registerTableView:_tableView identifier:[XYMeizuOrderPhotoCell defaultReuseId]];
        [XYQRCodeCell xy_registerTableView:_tableView identifier:[XYQRCodeCell defaultReuseId]];
        [XYPlatformFeeCell xy_registerTableView:_tableView identifier:[XYPlatformFeeCell defaultReuseId]];
        _tableView.dataSource = self;
        _tableView.delegate = self;//delegate和source放最后，否则在iOS8上代理方法会先执行，导致fd计算高度崩溃
    }
    return _tableView;
}

- (XYQRCodeCell*)qrCell{
    if (!_qrCell) {
        _qrCell = [[[NSBundle mainBundle]loadNibNamed:[XYQRCodeCell defaultReuseId] owner:self options:nil]lastObject];
        [_qrCell initAndAutoLoadQrCode:self.viewModel.orderDetail.bid delegate:self];//自动获取微信二维码
    }
    return _qrCell;
}

- (XYOrderDetailButtonsView*)buttonView{
    if (!_buttonView) {
        _buttonView = [XYOrderDetailButtonsView buttonsViewWithFrame:CGRectMake(0, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - 60 - LINE_HEIGHT, SCREEN_WIDTH, 60)];
        _buttonView.backgroundColor = [UIColor whiteColor];
        [_buttonView addSubview:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(207,214,224)]];
        __weak typeof(self) weakSelf = self;
        _buttonView.tapBlock = ^(NSInteger buttonIndex){
            [weakSelf changeOrderStatus:buttonIndex];
        };
    }
    return _buttonView;
}

- (XYRepairDetailViewController*)selectionController{
    if (!_selectionController) {
        _selectionController = [[XYRepairDetailViewController alloc]init];
    }
    return _selectionController;
}

-(void)initPlatformFeeBarView {
    _platformFeeBarView = [[XYPlatformFeeBarView alloc]init];
    _platformFeeBarView.hidden = YES;
    [self.view addSubview:_platformFeeBarView];
    [_platformFeeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(60);
    }];
    __weak __typeof(self)weakSelf = self;
    [_platformFeeBarView setSubmitFeeBlock:^{
        [weakSelf submitFeeRequest];
    }];
}

- (void)submitFeeRequest {
    [self showLoadingMask];
    XYAllTypeOrderDto *feeDto = [[XYAllTypeOrderDto alloc] init];
    feeDto.id = self.viewModel.orderDetail.id;
    __weak __typeof(self)weakSelf = self;
    [self.payUtil alipayPlatformfeeWithId_str:feeDto.id success:^{
        [weakSelf hideLoadingMask];
        [weakSelf showToast:@"平台费支付成功"];
        [weakSelf loadOrderDetail];
        [weakSelf postEditOrderNotification];
        if ([weakSelf numberOfSectionsInTableView:weakSelf.tableView] > 0)
        {
            NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    } failure:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

#pragma mark - reload views

- (void)reloadUIViews{
    [self resetRepairSelections];//右上角选项
    [self resetTableView];//列表
    [self resetButtonsView];//底部按钮
    [self resetPlatformFeeBarView];//平台费栏
}

//右上角选项
- (void)resetRepairSelections{
    if ([self.viewModel isMeizuOrder]) {
        self.navigationItem.rightBarButtonItem = nil;//如果是魅族，不要
    }else{
        self.navigationItem.rightBarButtonItem = [self.viewModel shouldShowRepairSelections]?[[UIBarButtonItem alloc]initWithTitle:@"维修信息" style:UIBarButtonItemStylePlain target:self action:@selector(goToRepairDetail)]:nil;
    }
}

//列表
- (void)resetTableView{
    self.tableView.hidden =false;
    [self.tableView reloadData];
    if ((self.viewModel.orderDetail.rightUtilityButtons!=nil && self.viewModel.orderDetail.rightUtilityButtons.count > 0) || (self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusUnpaid && self.viewModel.orderDetail.type ==XYAllOrderTypeRepair)) {
       self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - 60);
    }else{
       self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT);
    }
}

//底部按钮
- (void)resetButtonsView{
    [self.buttonView resetWithButtons:self.viewModel.orderDetail.rightUtilityButtons];
}

- (void)resetPlatformFeeBarView{
    if (self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusUnpaid && self.viewModel.orderDetail.type ==XYAllOrderTypeRepair) {
        self.platformFeeBarView.hidden = NO;
        self.platformFeeBarView.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.viewModel.orderDetail.platform_fee];
    }else {
        self.platformFeeBarView.hidden = YES;
        
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYOrderDetailCellType type = [self.viewModel getCellTypeByPath:indexPath];
    switch (type) {
        case XYOrderDetailCellTypePlatformFee:
        {
            if (self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusNoExist) {
                return 0;
            }else {
                return 45;
            }
        }
        case XYOrderDetailCellTypeAlipaySerialNumber:
        {
            if (self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusNoExist||self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusUnpaid) {
                return 0;
            }else {
                return 45;
            }
        }
        case XYOrderDetailCellTypePayQRCode:
            return [XYQRCodeCell defaultHeight];
        case XYOrderDetailCellTypeDevicePhoto:
            return [XYRepairOrderPhotoCell getHeightByVIP:self.viewModel.orderDetail.isVip];
        case XYOrderDetailCellTypeMeizuPhotos:
            return [XYMeizuOrderPhotoCell getHeightByVIP:self.viewModel.orderDetail.isVip];
        case XYOrderDetailCellTypeComment:
            return [tableView fd_heightForCellWithIdentifier:[XYCommentCell defaultReuseId] cacheByIndexPath:indexPath configuration:^(XYCommentCell* cell) {
                [cell setData:self.viewModel.comment];
            }];
        case XYOrderDetailCellTypeMeizuFaults:
        {   //故障标签，自适应高度
            XYFaultTagsCell *cell = [self getTagsCell];
            return MAX(48, [cell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1);
        }
        case XYOrderDetailCellTypeUserRemark:
        case XYOrderDetailCellTypeMeizuUserRemark:
        case XYOrderDetailCellTypeInternalRemark:
        case XYOrderDetailCellTypeEngineerRemark:
        {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:[SimpleAlignCell defaultReuseId] configuration:^(SimpleAlignCell* cell) {
                cell.xyDetailLabel.text = XY_NOTNULL([self.viewModel getContentByType:type], @"");
//                cell.xyDetailLabel.text = @"Patica订单核对信息不收费拿工单维修客户是9-8点都有空订单号：WX170701212210985下单时间：2017-07-01 21:22:11派单时间：2017-07-06 11:18:48手机信息：苹果 iPhone7 Plus 黑IMEI：355372087924159外屏碎 638";
            }];
            return MAX(45, height);
        }
        default:
            break;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case XYOrderDetailSectionTypeDeviceInfo:
        case XYOrderDetailSectionTypeRepairInfo:
        case XYOrderDetailSectionTypePricesAndGuarantee:
        case XYOrderDetailSectionTypeOthers:
            return 10;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case XYOrderDetailSectionTypeDeviceInfo:
        case XYOrderDetailSectionTypeRepairInfo:
        case XYOrderDetailSectionTypePricesAndGuarantee:
        case XYOrderDetailSectionTypeOthers:
            return [XYWidgetUtil getSectionHeader:nil height:10 headerId:@"XYOrderDetailHeaderFooter"];
            break;
        default:
            break;
    }
    return [UIView new];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYOrderDetailCellType type = [self.viewModel getCellTypeByPath:indexPath];
    switch (type) {
        case XYOrderDetailCellTypeTop:
            return [self getTopCell];
        case XYOrderDetailCellTypePlatformFee:
            return [self getPlatformFeeCell];
        case XYOrderDetailCellTypePayQRCode:
            return self.qrCell;
        case XYOrderDetailCellTypeComment:
            return [self getCommentCell];
        case XYOrderDetailCellTypeDevicePhoto:
            return self.photoCell;
        case XYOrderDetailCellTypeMeizuPhotos:
            return self.meizuPhotoCell;
        case XYOrderDetailCellTypeOtherFaults:
        case XYOrderDetailCellTypeMeizuOtherFaults:
            return [self getOtherFaultsCell];
        case XYOrderDetailCellTypeOtherFaults_noRecyle:
            return [self getOtherFaults_noRecyleCell];
        case XYOrderDetailCellTypeGuarantee:
            return [self getGuaranteeCell];
        case XYOrderDetailCellTypePlan:
        case XYOrderDetailCellTypeDevice:
            return [self getEditSelectCellForType:type];
        case XYOrderDetailCellTypeRepairTime:
        case XYOrderDetailCellTypeSerialNumber:
        case XYOrderDetailCellTypeEngineerRemark:
        case XYOrderDetailCellTypeMeizuEngineerRemark:
        {
            if ([self.viewModel getInputableByType:type]) {
                return [self getEditableCellForType:type];
            }
            break;
        }
        case XYOrderDetailCellTypeMeizuFaults:
            return [self getTagsCell];
        case XYOrderDetailCellTypeMeizuVIPCode:
        case XYOrderDetailCellTypeMeizuSNCode:
            return [self getVerifyCodeCellForType:type];
        default:
            break;
    }
    return [self getSimpleCellForType:type];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    XYOrderDetailCellType type = [self.viewModel getCellTypeByPath:indexPath];
    switch (type) {
        case XYOrderDetailCellTypeAddress:
            [self goToRouteGuidance];
            break;
        case XYOrderDetailCellTypePhone:
            [self callUserPhone];
            break;
        case XYOrderDetailCellTypePlan:
        {
            if ([self.viewModel getSelectableByType:type]) {
                [self goToEditPlan];
            }
            break;
        }
        case XYOrderDetailCellTypeRepairTime:
        case XYOrderDetailCellTypeSerialNumber:
        case XYOrderDetailCellTypeEngineerRemark:
        case XYOrderDetailCellTypeMeizuEngineerRemark:
        {
            if ([self.viewModel getInputableByType:type]) {
                [((SimpleEditCell*)cell)startEditing];
            }
            break;
        }
        case XYOrderDetailCellTypeOtherFaults:
        {
            if([self.viewModel isBeforeRepairingDone]){
               [self editOtherFaultsSelection];
            }
            break;
        }
        case XYOrderDetailCellTypeOtherFaults_noRecyle:
        {
            if([self.viewModel isBeforeRepairingDone]){
                [self editOtherFaults_noRecyleSelection];
            }
            break;
        }
        case XYOrderDetailCellTypeDevice:
            //[self goToEditDevice];//暂时屏蔽修改机型功能 20161205
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - cell

- (XYFaultTagsCell*)getTagsCell{
    XYFaultTagsCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYFaultTagsCell defaultReuseId]];
    cell.delegate = self;
    [cell setPlanIds:self.viewModel.orderDetail.rp_id names:self.viewModel.orderDetail.FaultTypeDetail];
    cell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    return cell;
}

- (XYVerifyCodeCell*)getVerifyCodeCellForType:(XYOrderDetailCellType)type{
    XYVerifyCodeCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYVerifyCodeCell defaultReustId]];
    cell.xyTitleLabel.text = [self.viewModel getTitleByType:type];
    cell.xyDetailField.text = XY_NOTNULL([self.viewModel getContentByType:type],@"");;
    cell.xyDetailField.userInteractionEnabled = [self.viewModel getInputableByType:type];
    cell.verifyButton.hidden = ![self.viewModel getInputableByType:type];
    cell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    [cell setDidTapButton:^(NSString *text){
        if (![XYStringUtil isNullOrEmpty:text]) {
            if (type == XYOrderDetailCellTypeMeizuSNCode) {
                [self.viewModel editDeviceSerialNumberInto:text];
            }else if(type == XYOrderDetailCellTypeMeizuVIPCode){
                [self.viewModel editVipCodeInto:text];
            }
        }
    }];
    return cell;
}

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    if ([self.viewModel isMeizuOrder]) {
        topCell.orderIdLabel.text = [NSString stringWithFormat:@"订单 %@",XY_NOTNULL(self.viewModel.orderDetail.order_num,@"")];
    }else{
        topCell.orderIdLabel.text = [NSString stringWithFormat:@"订单 %@",XY_NOTNULL(self.viewModel.orderDetail.id,@"")];
    }
    topCell.statusLabel.text = self.viewModel.orderDetail.statusString;
    return topCell;
}

- (XYPlatformFeeCell*)getPlatformFeeCell{
    XYPlatformFeeCell* platformFeeCell = [self.tableView dequeueReusableCellWithIdentifier:[XYPlatformFeeCell defaultReuseId]];
    platformFeeCell.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.viewModel.orderDetail.platform_fee];
    platformFeeCell.payStatusLabel.text = self.viewModel.orderDetail.platform_pay_status_name;
    if (self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusNoExist) {
        platformFeeCell.hidden = YES;
    }else {
        platformFeeCell.hidden = NO;
    }
    return platformFeeCell;
}

- (XYRepairOrderPhotoCell*)photoCell{
    if (!_photoCell) {
        _photoCell = [[[NSBundle mainBundle]loadNibNamed:[XYRepairOrderPhotoCell defaultReuseId] owner:self options:nil]lastObject];
        _photoCell.delegate = self;
    }
    [_photoCell setVip:self.viewModel.orderDetail.isVip];
    [_photoCell setUrl:self.viewModel.orderDetail.devnopic1 localImage:self.viewModel.cachedPhotoMap[xy_photo_cell_devno_pic1] forName:xy_photo_cell_devno_pic1];
    [_photoCell setUrl:self.viewModel.orderDetail.devnopic2 localImage:self.viewModel.cachedPhotoMap[xy_photo_cell_devno_pic2] forName:xy_photo_cell_devno_pic2];
    [_photoCell setUrl:self.viewModel.orderDetail.devnopic4 localImage:self.viewModel.cachedPhotoMap[xy_photo_cell_devno_pic4] forName:xy_photo_cell_devno_pic4];
    [_photoCell setUrl:self.viewModel.orderDetail.devnopic3 localImage:self.viewModel.cachedPhotoMap[xy_photo_cell_devno_pic3] forName:xy_photo_cell_devno_pic3];
    _photoCell.canRetakePhoto = [self.viewModel isBeforeRepairingDone];
    return _photoCell;
}

- (XYMeizuOrderPhotoCell*)meizuPhotoCell{
    if (!_meizuPhotoCell) {
        _meizuPhotoCell = [[[NSBundle mainBundle]loadNibNamed:[XYMeizuOrderPhotoCell defaultReuseId] owner:self options:nil]lastObject];
        _meizuPhotoCell.delegate = self;
    }
    [_meizuPhotoCell setVip:self.viewModel.orderDetail.isVip];
    [_meizuPhotoCell setUrl:self.viewModel.orderDetail.devnopic1 localImage:self.viewModel.cachedPhotoMap[mz_photo_cell_devno_pic1] forName:mz_photo_cell_devno_pic1];
    [_meizuPhotoCell setUrl:self.viewModel.orderDetail.devnopic2 localImage:self.viewModel.cachedPhotoMap[mz_photo_cell_devno_pic2] forName:mz_photo_cell_devno_pic2];
    [_meizuPhotoCell setUrl:self.viewModel.orderDetail.devnopic3 localImage:self.viewModel.cachedPhotoMap[mz_photo_cell_devno_pic3] forName:mz_photo_cell_devno_pic3];
    [_meizuPhotoCell setUrl:self.viewModel.orderDetail.receipt_pic localImage:self.viewModel.cachedPhotoMap[mz_photo_cell_receipt_pic] forName:mz_photo_cell_receipt_pic];
    _meizuPhotoCell.canRetakePhoto = [self.viewModel isBeforeRepairingDone];
    return _meizuPhotoCell;
}

- (XYCommentCell*)getCommentCell{
    XYCommentCell* commentCell = [self.tableView dequeueReusableCellWithIdentifier:[XYCommentCell defaultReuseId]];
    [commentCell setData:self.viewModel.comment];
    return commentCell;
}

- (XYOtherFaultsCell*)getOtherFaultsCell{
    XYOtherFaultsCell* otherCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOtherFaultsCell defaultReuseId]];
    otherCell.noteLabel.text = self.viewModel.orderDetail.extraMes;
    otherCell.titleLabel.text = @"屏幕折旧：";
    [otherCell setFaultSelected:self.viewModel.orderDetail.allowExtraPrice];
    otherCell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    return otherCell;
}

- (XYOtherFaultsCell*)getOtherFaults_noRecyleCell{
    XYOtherFaultsCell* otherCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOtherFaultsCell defaultReuseId]];
    otherCell.noteLabel.text = self.viewModel.orderDetail.extraMes_noRecyle;
    otherCell.titleLabel.text = @"不回收配件：";
    [otherCell setFaultSelected:self.viewModel.orderDetail.allowExtraPrice_noRecyle];
    otherCell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    return otherCell;
}

- (XYGuaranteeStatusCell*)getGuaranteeCell{
    XYGuaranteeStatusCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYGuaranteeStatusCell defaultReuseId]];
    cell.delegate = self;
    [cell setGuaranteeStatus:self.viewModel.orderDetail.brand_warranty_status];
    cell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    return cell;
}

- (SimpleEditCell*)getEditableCellForType:(XYOrderDetailCellType)type{
    SimpleEditCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[SimpleEditCell defaultReuseId]];
    cell.editCellDelegate = self;
    cell.xyTitleLabel.text = XY_NOTNULL([self.viewModel getTitleByType:type],@"");
    cell.inputField.text = XY_NOTNULL([self.viewModel getContentByType:type], @"") ;
    switch (type) {
        case XYOrderDetailCellTypeRepairTime:
            [cell setEditType:XYSimpleEditCellTypeOrderedTime];
            break;
        case XYOrderDetailCellTypeSerialNumber:
            [cell setEditType:XYSimpleEditCellTypeSerialNumber];
            break;
        case XYOrderDetailCellTypeEngineerRemark:
        case XYOrderDetailCellTypeMeizuEngineerRemark:
            [cell setEditType:XYSimpleEditCellTypeRemark];
            break;
        default:
            [cell setEditType:XYSimpleEditCellTypeInvalid];
            break;
    }
    cell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    return cell;
}

- (XYEditSelectCell*)getEditSelectCellForType:(XYOrderDetailCellType)type{
    XYEditSelectCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYEditSelectCell defaultReuseId]];
    cell.xyTitleLabel.text = XY_NOTNULL([self.viewModel getTitleByType:type],@"");
    cell.xyContentLabel.text = XY_NOTNULL([self.viewModel getContentByType:type],@"");
    cell.arrowImage.hidden = ![self.viewModel getSelectableByType:type];
    cell.userInteractionEnabled = [self.viewModel isBeforeRepairingDone];
    return cell;
}

- (SimpleAlignCell*)getSimpleCellForType:(XYOrderDetailCellType)type{
    SimpleAlignCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = SIMPLE_TEXT_FONT;
    cell.xyTextLabel.textColor = LIGHT_TEXT_COLOR;
    cell.xyDetailLabel.font = SIMPLE_TEXT_FONT;
    cell.xyDetailLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = true;
    cell.xyTextLabel.text = XY_NOTNULL([self.viewModel getTitleByType:type],@"");
    
    //用户备注不限字数
    if (type == XYOrderDetailCellTypeMeizuUserRemark  || type == XYOrderDetailCellTypeUserRemark) {
        cell.xyDetailLabel.adjustsFontSizeToFitWidth = false;
    }else{
        cell.xyDetailLabel.adjustsFontSizeToFitWidth = true;
    }
    
    if(type == XYOrderDetailCellTypeTotalPrice || type == XYOrderDetailCellTypeMeizuTotalPrice){
        //价格显示逻辑
        [self configPriceCell:cell];
    }else{
        //普通显示
        cell.xyDetailLabel.text = XY_NOTNULL([self.viewModel getContentByType:type],@"");
        //蓝色的 电话和地址
        if (type == XYOrderDetailCellTypePhone || type == XYOrderDetailCellTypeAddress) {
            cell.xyDetailLabel.textColor = BLUE_COLOR;
        }
    }
    
    if (type == XYOrderDetailCellTypeAlipaySerialNumber) {
        if (self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusNoExist||self.viewModel.orderDetail.platform_pay_status==XYPlatformPayStatusUnpaid) {
            cell.hidden = YES;
        }else {
            cell.hidden = NO;
        }
    }
    
    return cell;
}

- (void)configPriceCell:(SimpleAlignCell*)cell{
    //价格显示逻辑
    if ([self.viewModel shouldShowOtherFaults] && ( self.viewModel.orderDetail.allowExtraPrice || self.viewModel.orderDetail.allowExtraPrice_noRecyle )) {
        //选中屏幕折旧
        if ([self.viewModel isBeforeRepairingDone]) {
            //维修完成前
            if (self.viewModel.orderDetail.allowExtraPrice) {
                cell.xyDetailLabel.text = [NSString stringWithFormat:@"￥%@=%@+%@元(屏幕折旧)",@(self.viewModel.orderDetail.TotalAccount + self.viewModel.orderDetail.extraPrices),@(self.viewModel.orderDetail.TotalAccount),@(self.viewModel.orderDetail.extraPrices)];
            }else if (self.viewModel.orderDetail.allowExtraPrice_noRecyle) {
                cell.xyDetailLabel.text = [NSString stringWithFormat:@"￥%@=%@+%@元(屏幕折旧)",@(self.viewModel.orderDetail.TotalAccount + self.viewModel.orderDetail.extraPrices_noRecyle),@(self.viewModel.orderDetail.TotalAccount),@(self.viewModel.orderDetail.extraPrices_noRecyle)];
            }
        }else{
            //维修完成后
            cell.xyDetailLabel.text = [NSString stringWithFormat:@"￥%@=%@+%@元(屏幕折旧)",@(self.viewModel.orderDetail.TotalAccount),@(self.viewModel.orderDetail.TotalAccount-self.viewModel.orderDetail.extraPrice),@(self.viewModel.orderDetail.extraPrice)];
        }
    }else{
        //不显示“屏幕折旧”cell 或 没选中屏幕折旧
        cell.xyDetailLabel.attributedText = self.viewModel.orderDetail.priceAndPay;
    }
}

#pragma mark - edit cell

- (void)onTimeEdited:(XYReservetimeDateDto*)date timePeriod:(XYReservetimePeriodDto *)timePeriod {
    NSString *reservetime = [XYDtoTransferer xy_reservetimeTransform:timePeriod.start_timestamp reserveTime2:timePeriod.next_timestamp];
    if (![reservetime isEqualToString:self.viewModel.orderDetail.repairTimeString]){
        [XYAlertTool showConfirmCancelAlert:@"确定将预约时间修改为:" message:reservetime onView:self action:^{
            [self showLoadingMask];
            [self.viewModel editRepairOrderedTime:timePeriod.start_timestamp reservetime2:timePeriod.next_timestamp];
        } cancel:^{
            [self.tableView reloadData];
        }];
    }
}

- (void)onEditingEnded:(NSString *)str type:(XYSimpleEditCellType)type{
    if(type == XYSimpleEditCellTypeOrderedTime){
        
    }else if (type == XYSimpleEditCellTypeSerialNumber){
        if (![str isEqualToString:self.viewModel.orderDetail.RepairNumber]){
            [XYAlertTool showConfirmCancelAlert:@"确定将设备序列号修改为:" message:str onView:self action:^{
                [self showLoadingMask];
                [self.viewModel editDeviceSerialNumberInto:str];
            } cancel:^{
                [self.tableView reloadData];
            }];
        }
    }else if (type == XYSimpleEditCellTypeRemark){
        if (![str isEqualToString:self.viewModel.orderDetail.selfRemark]){
            [self showLoadingMask];
            [self.viewModel editRemarkInto:str];
        }
    }
}

- (void)onDeviceSelected:(XYPHPDeviceDto*)device color:(NSString *)colorId newPlan:(NSString *)planId{
    [self.navigationController popToViewController:self animated:true];
    [XYAlertTool showConfirmCancelAlert:@"确定修改机型为" message:device.MouldName onView:self action:^{
        [self showLoadingMask];
        if ([self.viewModel isMeizuOrder]) {
            [self.viewModel addOrDeleteRepairPlan:planId device:device.Id color:colorId isAddOrDelete:true];//魅族修改机型
        }else{
            //普通修改机型
            [self.viewModel editRepairPlanInto:planId device:device.Id color:colorId];
        }
        
    } cancel:^{}];
}

- (void)onRepairingPlanSelected:(NSString *)planId color:(NSString *)colorName colorId:(NSString *)colorId repairType:(NSString *)planDescription{
    [self.navigationController popToViewController:self animated:true];
    if ([self.viewModel isMeizuOrder]) {
        //如果是魅族订单，则为添加维修方案
        [self showLoadingMask];
        [self.viewModel addOrDeleteRepairPlan:planId device:self.viewModel.orderDetail.moudleid color:colorId isAddOrDelete:true];
    }else{
        //否则是普通的修改
        [UIAlertView showWithTitle:@"确定将维修方案修改为" message:planDescription cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if(buttonIndex==1){
                [self showLoadingMask];
                [self.viewModel editRepairPlanInto:planId device:self.viewModel.orderDetail.moudleid color:colorId];
            }
        }];
    }
}

#pragma mark - qrcell

- (void)getQrCodeOfType:(XYQRCodePayType)type{
   [self.viewModel getPayCode:type];
}

#pragma mark - methods

- (void)loadOrderDetail{
    if ([XYStringUtil isNullOrEmpty:self.orderId]){
        [self showToast:TT_NO_ORDER_ID];
        return;
    }
    [self.viewModel loadOrderDetail:self.orderId bid:self.bid];
}

- (void)loadCachedImages{
    
    //如果缓存未加载完毕，忽略
    if (![XYOrderListManager sharedInstance].photosReady) {
        return;
    }
    
    if ([self.viewModel isMeizuOrder]) {
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:mz_photo_cell_devno_pic1 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:mz_photo_cell_devno_pic1];
            }
        }];
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:mz_photo_cell_devno_pic2 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:mz_photo_cell_devno_pic2];
            }
        }];
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:mz_photo_cell_devno_pic3 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:mz_photo_cell_devno_pic3];
            }
        }];
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeReceipt property:mz_photo_cell_receipt_pic result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:mz_photo_cell_receipt_pic];
            }
        }];
    }else{
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:xy_photo_cell_devno_pic1 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:xy_photo_cell_devno_pic1];
            }
        }];
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:xy_photo_cell_devno_pic2 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:xy_photo_cell_devno_pic2];
            }
        }];
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:xy_photo_cell_devno_pic4 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:xy_photo_cell_devno_pic4];
            }
        }];
        [[XYOrderListManager sharedInstance]getCachedImageOfOrder:self.orderId bid:self.bid type:XYPictureTypeRepairNumber property:xy_photo_cell_devno_pic3 result:^(UIImage *resultImg) {
            if (resultImg) {
                [self.viewModel.cachedPhotoMap setObject:resultImg forKey:xy_photo_cell_devno_pic3];
            }
        }];
    }
}

- (void)editOtherFaultsSelection{
    self.viewModel.orderDetail.allowExtraPrice_noRecyle = NO;
    self.viewModel.orderDetail.allowExtraPrice = !self.viewModel.orderDetail.allowExtraPrice;
    [self.tableView reloadData];
}

- (void)editOtherFaults_noRecyleSelection{
    self.viewModel.orderDetail.allowExtraPrice = NO;
    self.viewModel.orderDetail.allowExtraPrice_noRecyle = !self.viewModel.orderDetail.allowExtraPrice_noRecyle;
    [self.tableView reloadData];
}

- (void)changeOrderStatus:(NSInteger)tag{
    if (self.viewModel.orderDetail.status != XYOrderStatusRepaired){
        XYOrderStatus nextStatus = [XYOrderBase getClickedActionStatus:self.viewModel.orderDetail.status rightBtnIndex:tag];
        if (nextStatus == XYOrderStatusRepaired) {//维修完成前
            //维修完成增加提示 包括总价
            CGFloat totalPrice = self.viewModel.orderDetail.TotalAccount;
            if (self.viewModel.orderDetail.allowExtraPrice) {
                //如果有折旧费
                totalPrice += self.viewModel.orderDetail.extraPrices;
            }else if (self.viewModel.orderDetail.allowExtraPrice_noRecyle) {
                //如果有折旧费_不回收
                totalPrice += self.viewModel.orderDetail.extraPrices_noRecyle;
            }
            //前往维修完成选项
            [self goToCompleteOrderSelections:self.viewModel.orderDetail.MouldName plan:self.viewModel.orderDetail.FaultTypeDetail parts:self.viewModel.orderDetail.partName price:totalPrice];
        }else if(nextStatus == XYOrderStatusCancelled){
            [self cancelOrder];
        }else if(nextStatus == XYOrderStatusShopRepairing){
            [XYAlertTool showConfirmCancelAlert:@"确定门店维修？" message:nil onView:self action:^{
                [self showLoadingMask];
                [self.viewModel turnStateOfOrderInto:nextStatus];
            } cancel:nil];
        }else if(nextStatus == XYOrderStatusOnTheWay){
            [XYAlertTool showConfirmCancelAlert:@"确定出发？" message:nil onView:self action:^{
                [self showLoadingMask];
                [self.viewModel turnStateOfOrderInto:nextStatus];
            } cancel:nil];
        }else{
            [self showLoadingMask];
            [self.viewModel turnStateOfOrderInto:nextStatus];
        }
    }else{
        if (tag == 0) {
            [UIAlertView showWithTitle:@"是否确定已支付？" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if(buttonIndex==1){[self showLoadingMask];[self.viewModel payOrderByCash];};
            }];
        }else{
            //展示支付方式-》
            UIActionSheet* paySheet = [[UIActionSheet alloc]initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付",@"支付宝支付", nil];
            paySheet.tag = XYOrderDetailActionSheetPay;
            [paySheet showFromTabBar:self.tabBarController.tabBar];
       }
    }
}


#pragma mark - 工程师代付

- (XYPayUtil*)payUtil{
    if (!_payUtil) {
        _payUtil = [[XYPayUtil alloc]init];
    }
    return _payUtil;
}

- (void)onWechatPaid:(NSNotification*)note{
    [self hideLoadingMask];
    if([note.object isKindOfClass:[PayResp class]]){
        PayResp* resp = note.object;
        switch (resp.errCode) {
            case WXSuccess:
                [self showToast:@"支付完成，系统处理中，如订单状态未改变，请手动刷新"];
                [self performSelector:@selector(loadOrderDetail) withObject:nil afterDelay:2.0];
                break;
            default:
                [self showToast:resp.errStr];
                break;
        }
    }
}

- (void)handlePayActionIndex:(NSInteger)buttonIndex{
    XYPayOpenModel* model = [[XYOrderListManager sharedInstance].payOpenMap objectForKey:[NSString stringWithFormat:@"%@",@(self.viewModel.orderDetail.bid)]];
    if (buttonIndex == 0){//微信支付
        if (!model.anotherpayweixin) {
            [self showToast:@"此订单不可使用微信代付"];
            return;
        }
        [self showLoadingMask];
        __weak typeof(self) weakSelf = self;
        [self.payUtil wechatPayWithOrderId:self.orderId info:self.viewModel.orderDetail.FaultTypeDetail price:self.viewModel.orderDetail.TotalAccount success:^{
            [weakSelf hideLoadingMask];
        } failure:^(NSString *error) {
            [weakSelf hideLoadingMask];
            [weakSelf showToast:error];
        }];
    }else if(buttonIndex == 1){//支付宝支付
        if (!model.anotherpayalipay) {
            [self showToast:@"此订单不可使用支付宝代付"];
            return;
        }
        [self showLoadingMask];
        __weak typeof(self) weakSelf = self;
        [self.payUtil alipayWithOrderId:self.orderId success:^{
            [weakSelf hideLoadingMask];
            [weakSelf showToast:@"支付完成，系统处理中，如订单状态未改变，请手动刷新"];
            [weakSelf performSelector:@selector(loadOrderDetail) withObject:nil afterDelay:2.0];
        } failure:^(NSString *error) {
            [weakSelf hideLoadingMask];
            [weakSelf showToast:error];
        }];
    }
}

#pragma mark - actionsheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case XYOrderDetailActionSheetPhoto:
            [self handlePhotoActionButtonIndex:buttonIndex];
            break;
        case XYOrderDetailActionSheetPay:
            [self handlePayActionIndex:buttonIndex];
            break;
        default:
            break;
    }
}

#pragma mark - action

- (void)willChangeGuaranteeStatusInto:(XYGuarrantyStatus)status{
    if(self.viewModel.orderDetail.status == XYOrderStatusDone || self.viewModel.orderDetail.status == XYOrderStatusCancelled || self.viewModel.orderDetail.payStatus){
        return;//只有还没完成、没支付的订单能改保修状态?
    }
    [self showLoadingMask];
    [self.viewModel editGuarranteeInto:status];
}

- (void)addFault{
    [self goToEditPlan];
}

- (void)removeFault:(NSString *)planId faultName:(NSString *)name{
    [XYAlertTool showConfirmCancelAlert:@"确定删除该故障及其维修方案" message:name onView:self action:^{
        [self.viewModel addOrDeleteRepairPlan:planId device:self.viewModel.orderDetail.moudleid color:nil isAddOrDelete:false];
    } cancel:^{}];
}

- (void)goToCompleteOrderSelections:(NSString*)device plan:(NSString*)plan parts:(NSString*)parts price:(CGFloat)price{
    
    if(!([self.viewModel getPhotoTakingAvailable]&&[self.viewModel getPhotoSavingAvailable])){
        [self showToast:@"请打开应用摄像头及相册使用权限"];
        return;
    }
    
    self.selectionController.device = device;
    self.selectionController.plan = plan;
    self.selectionController.parts = parts;
    self.selectionController.totalPrice = price;
    self.selectionController.viewModel = self.viewModel;
    [self.navigationController pushViewController:self.selectionController animated:true];
}

- (void)goToEditDevice{
    XYSelectDeviceTypeViewController* deviceViewController = [[XYSelectDeviceTypeViewController alloc]initWithType:XYOrderDeviceTypeRepair allowCustomize:false delegate:self allowedBrand:self.viewModel.orderDetail.brandid allowedColor:nil];
    [self.navigationController pushViewController:deviceViewController animated:true];
}

- (void)goToEditPlan{
    NSString* allowedColor = [self.viewModel isMeizuOrder]?self.viewModel.orderDetail.color_id:nil;
    XYSelectPlanViewController* selectPlanViewController = [[XYSelectPlanViewController alloc]initWithDevice:self.viewModel.orderDetail.moudleid brand:self.viewModel.orderDetail.brandid bid:self.viewModel.orderDetail.bid allowedColor:allowedColor editOrderType:self.viewModel.orderDetail.order_status];
    selectPlanViewController.delegate = self;
    [self.navigationController pushViewController:selectPlanViewController animated:true];
}

- (void)goToRouteGuidance{
    if ([XYStringUtil isNullOrEmpty:_viewModel.orderDetail.address]) {
        [self showToast:TT_NO_ADDRESS];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.viewModel.orderDetail.address];
    XYTargetLocationViewController* mapLocationViewController = [[XYTargetLocationViewController alloc]initWithTargetAddress:self.viewModel.orderDetail.address area:self.viewModel.orderDetail.area];
    [self.navigationController pushViewController:mapLocationViewController animated:true];
}

- (void)cancelOrder{
    XYCancelOrderViewController* cancelViewController = [[XYCancelOrderViewController alloc]init];
    cancelViewController.orderId = self.orderId;
    cancelViewController.bid = self.bid;
    [self.navigationController pushViewController:cancelViewController animated:true];
}

- (void)goToRepairDetail{
    if (![self.viewModel isBeforeRepairingDone]) {
        //已完成 显示自己的
        XYRepairSelectionsViewController* repairDetailController = [[XYRepairSelectionsViewController alloc]initWithOrderId:self.viewModel.orderDetail.id orderNum:self.viewModel.orderDetail.order_num bid:self.viewModel.orderDetail.bid isAfterSale:false];
        [self.navigationController pushViewController:repairDetailController animated:true];
    }else{
        //否则 显示售后的
        XYRepairSelectionsViewController* repairDetailController = [[XYRepairSelectionsViewController alloc]initWithOrderId:self.viewModel.orderDetail.origin_order_id orderNum:self.viewModel.orderDetail.order_num bid:self.viewModel.orderDetail.bid isAfterSale:true];
        [self.navigationController pushViewController:repairDetailController animated:true];
    }

}

- (void)goBack{//键盘出现时不许返回
    if (_isKeyboardVisible) {
        return;
    }
    [super goBack];
}

#pragma mark - phone call

- (void)callUserPhone{
    if (IS_IOS_10_LATER) {
        [XYAlertTool callPhone:self.viewModel.orderDetail.uMobile onView:self];
    }else {
        [XYAlertTool showPhoneAlert:self.viewModel.orderDetail.uMobile onView:self];
    }
    #warning XYAlertTool
//    [XYAlertTool showPhoneAlert:self.viewModel.orderDetail.uMobile onView:self];
}

#pragma mark - photo

- (void)takePictureWithName:(NSString *)name{

    if (self.viewModel.orderDetail.status != XYOrderStatusOnTheWay &&
        self.viewModel.orderDetail.status != XYOrderStatusRepairing &&
        self.viewModel.orderDetail.status != XYOrderStatusShopRepairing) {
        [self showToast:@"只有已出发订单可上传照片"];
        return;//只有已出发后状态才能传照片 2016.08.23需求
    }
    
    if(![self.viewModel getPhotoTakingAvailable]){
        [self showToast:@"请打开应用摄像头使用权限"];
        return;
    }
    
    if ([self.viewModel isMeizuOrder]) {
        self.meizuPhotoCell.currentPictureTakenName = name;
    }else{
        self.photoCell.currentPictureTakenName = name;
    }
    
    //选项
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",nil];
    sheet.tag = XYOrderDetailActionSheetPhoto;
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)uploadPicture:(UIImage *)img name:(NSString *)name{
    //上传图片（目前仅限 序列号和发票照片）
//    UIImage *resizedImg = [XYCompressImageuUtil resizeImage:img];
    NSData* data = UIImageJPEGRepresentation(img,0.5);
    [self showLoadingMask];
    if ([self.viewModel isMeizuOrder]) {
        //兼容魅族
        if ([name isEqualToString:mz_photo_cell_receipt_pic]) {
            //发票照片
            [self.viewModel uploadAsynPhoto:data type:XYPictureTypeReceipt repeatCount:0 orderId:self.viewModel.orderDetail.id bid:self.viewModel.orderDetail.bid name:mz_photo_cell_receipt_pic onSuccess:^(NSString *url) {
                [self hideLoadingMask];
                [self.meizuPhotoCell setUrl:url localImage:nil forName:name];
                self.meizuPhotoCell.currentPictureTakenName = nil;
            } onFailure:^{
                [self hideLoadingMask];
                [self showToast:@"上传失败，请点击重传"];
                [self.meizuPhotoCell setUrl:nil localImage:img forName:name];
                self.meizuPhotoCell.currentPictureTakenName = nil;
            }];
        }else{
            //序列号照片
            [self.viewModel uploadAsynPhoto:data type:XYPictureTypeRepairNumber repeatCount:0 orderId:self.viewModel.orderDetail.id bid:self.viewModel.orderDetail.bid name:name onSuccess:^(NSString *url) {
                [self hideLoadingMask];
                [self.meizuPhotoCell setUrl:url localImage:nil forName:name];
                self.meizuPhotoCell.currentPictureTakenName = nil;
            } onFailure:^{
                [self hideLoadingMask];
                [self showToast:@"上传失败，请点击重传"];
                [self.meizuPhotoCell setUrl:nil localImage:img forName:name];
                self.meizuPhotoCell.currentPictureTakenName = nil;
            }];
        }
    }else{

        [self.viewModel uploadAsynPhoto:data type:XYPictureTypeRepairNumber repeatCount:0 orderId:self.viewModel.orderDetail.id bid:self.viewModel.orderDetail.bid name:name onSuccess:^(NSString *url) {
            [self hideLoadingMask];
            [self.photoCell setUrl:url localImage:nil forName:name];
            self.photoCell.currentPictureTakenName = nil;
        } onFailure:^{
            [self hideLoadingMask];
            [self showToast:@"上传失败，请点击重传"];
            [self.photoCell setUrl:nil localImage:img forName:name];
            self.photoCell.currentPictureTakenName = nil;
        }];
    }
}

- (void)handlePhotoActionButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){ //|| buttonIndex == 1){ //删除手机相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:
           UIImagePickerControllerSourceTypeCamera]){
           picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
           [self showToast:@"设备不支持拍照"];
           return;
        }
        [self presentViewController:picker animated:true completion:nil];
    }else{
        //取消拍摄
        if ([self.viewModel isMeizuOrder]) {
            self.meizuPhotoCell.currentPictureTakenName = nil;
        }else{
            self.photoCell.currentPictureTakenName = nil;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //压缩保存图片
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *rotatedOriginalImage = [XYWidgetUtil rotateImage:originalImage];
    NSData* data = [XYWidgetUtil resetSizeOfImageData:rotatedOriginalImage maxSize:100];
    TTDEBUGLOG(@"data:%@k",@(data.length/1024.0));
    if([self.viewModel getPhotoSavingAvailable]){
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){//现拍的，先保存到相册
            UIImage* finalImage = [UIImage imageWithData:data];
            UIImageWriteToSavedPhotosAlbum(finalImage, self, nil, NULL);
        }
    }
    [picker dismissViewControllerAnimated:true completion:nil];
    //上传图片
    [self uploadPicture:[UIImage imageWithData:data] name:[self.viewModel isMeizuOrder]?self.meizuPhotoCell.currentPictureTakenName:self.photoCell.currentPictureTakenName];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - call back
#warning vm fix
- (void)getReservetimeData:(NSString*)cityID{
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getReservetimeByCityID:cityID success:^(NSArray *dateList) {
        [[HttpCache sharedInstance] setObject:dateList forKey:cache_reservetimeList];
    } errorString:^(NSString *error) {
        [weakself showToast:error];
        [[HttpCache sharedInstance] setObject:nil forKey:cache_reservetimeList];
    }];
}


- (void)onOrderDetailLoaded:(BOOL)success noteString:(NSString *)str{
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    [self hideLoadingMask];
    if(success){
        self.orderId = self.viewModel.orderDetail.id;
        self.bid = self.viewModel.orderDetail.bid;
        [self reloadUIViews];//更新UI
//        [self postEditOrderNotification];
        if (self.viewModel.orderDetail.is_comment && (!self.viewModel.comment)) {
            //获取评论
            [self.viewModel loadUserComment:self.orderId];
        }
        [self getReservetimeData:self.viewModel.orderDetail.city];
    }else{
        [self showToast:str];
    }
}

- (void)postEditOrderNotification{
    if ([self.viewModel isBeforeRepairingDone]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_EDIT_REPAIR_NEW_ORDER object:self.viewModel.orderDetail];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_EDIT_REPAIR_OLD_ORDER object:self.viewModel.orderDetail];
    }
}

- (void)onOrderCommentLoaded:(BOOL)success noteString:(NSString *)str{
    if (success){
        [self.tableView reloadData];
    }else{
        [self showToast:str];
    }
}

- (void)onDeviceSerialNumberEdited:(BOOL)success noteString:(NSString *)str{
    [self hideLoadingMask];
    [self showToast:success?TT_EDIT_SUCCESS:str];
    //如果是魅族订单，要刷新获取新价格
    if (success && [self.viewModel isMeizuOrder]) {
        [self loadOrderDetail];
        if ([self.viewModel canScanQRCode]) {
            [self.qrCell resetQRCodes];//价格变更，重置二维码
        }
    }
}

- (void)onVIPCodeEdited:(BOOL)success noteString:(NSString*)str{
    [self hideLoadingMask];
    [self showToast:success?TT_EDIT_SUCCESS:str];
    //刷新获取新价格
    if (success) { [self loadOrderDetail]; }
}


- (void)onPreOrderTimeEdited:(BOOL)success noteString:(NSString *)str{
    [self hideLoadingMask];
    if(success){
        [self showToast:TT_EDIT_SUCCESS];
        [self.delegate onOrderStatusChanged:self.viewModel.orderDetail];
        [self postEditOrderNotification];
    }else{
        [self.tableView reloadData];
        [self showToast:str];
    }
}

- (void)onRepairPlanEdited:(BOOL)success noteString:(NSString *)str{
    if (success){
        [self showToast:TT_EDIT_SUCCESS];
        [self.viewModel loadOrderDetail:self.orderId bid:self.bid];
        if ([self.viewModel canScanQRCode]) {
            [self.qrCell resetQRCodes];//价格变更，重置二维码
        }
    }else{
        [self hideLoadingMask];
        [self.tableView reloadData];
        [self showToast:str];
    }
}

- (void)onRemarkEdited:(BOOL)success noteString:(NSString *)str{
    [self hideLoadingMask];
    if(success){
        [self showToast:TT_EDIT_SUCCESS];
    }else{
        [self.tableView reloadData];
        [self showToast:str];
    }
}

- (void)onPayQRCodeLoaded:(BOOL)success type:(XYQRCodePayType)type code:(NSString *)code price:(NSString *)price noteString:(NSString *)str{
    [self hideLoadingMask];
    if (!success) {
        [self showToast:str?str:@"获取二维码失败"];
    }else{
        //开始重复检测支付状态 Orz
        [self.viewModel checkPaymentStatusRepeatedly];
    }
    [self.qrCell setQRCode:code price:price type:type bid:self.viewModel.orderDetail.bid success:success];
}

- (void)onOrderPaidByCash:(BOOL)success noteString:(NSString *)str{
    [self hideLoadingMask];
    if (success){

        [self resetViewsOnPaid];
        [self.delegate onOrderStatusChanged:self.viewModel.orderDetail];
        [self postEditOrderNotification];
        [self loadOrderDetail];
        if ([self numberOfSectionsInTableView:self.tableView] > 0)
        {
            NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }else{
        [self showToast:str];
    }
}

- (void)resetViewsOnPaid{
    self.viewModel.orderDetail.payStatus= true;
    self.viewModel.orderDetail.payment = XYPaymentTypePaidByCash;
    self.viewModel.orderDetail.status = XYOrderStatusDone;
    self.viewModel.orderDetail.statusString=nil;
    self.viewModel.orderDetail.priceAndPay=nil;
    [self.tableView reloadData];
    self.buttonView.hidden = true;
    self.tableView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT);
}

- (void)onOrderStatusChangedInto:(XYOrderStatus)status{
    [self.delegate onOrderStatusChanged:self.viewModel.orderDetail];
    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
    if ((status == XYOrderStatusDone) || (status == XYOrderStatusRepaired)){
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_OLD_ORDER object:nil];
    }
    if (status == XYOrderStatusDeleted){
        [self goBack];
    }else{
        [self.viewModel loadOrderDetail:self.orderId bid:self.bid];
    }
}

- (void)onGuarranteeEdited:(BOOL)success noteString:(NSString *)str{
    [self hideLoadingMask];
    if(success){
        [self showToast:TT_EDIT_SUCCESS];
    }else{
        [self showToast:str];
    }
}

- (void)onOrderStatusChangingFailed:(NSString *)error{
    [self hideLoadingMask];
    [self showToast:error];
}

#pragma mark - keyboard

- (void)keyboardDidShow{
    _isKeyboardVisible = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)keyboardDidHide{
    _isKeyboardVisible = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
