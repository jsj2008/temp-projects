//
//  XYOrderDetailViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/30.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderDetailViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "XYOrderListManager.h"
#import "XYStringUtil.h"
#import "XYLocationManagerWithTimer.h"


@implementation XYOrderDetailViewModel

- (XYOrderDetail*)orderDetail{
    if (!_orderDetail) {
        _orderDetail = [[XYOrderDetail alloc]init];
    }
    return _orderDetail;
}
//表驱动 cell展示数据
- (NSMutableDictionary*)titleMap{
    if (!_titleMap) {
        _titleMap = [[NSMutableDictionary alloc]init];
        [_titleMap setValue:@"审核备注：" forKey:EnumToKey(XYOrderDetailCellTypeCancelRemark)];
        [_titleMap setValue:@"客户姓名：" forKey:EnumToKey(XYOrderDetailCellTypeName)];
        [_titleMap setValue:@"联系方式：" forKey:EnumToKey(XYOrderDetailCellTypePhone)];
        [_titleMap setValue:@"联系地址：" forKey:EnumToKey(XYOrderDetailCellTypeAddress)];
        [_titleMap setValue:@"订单类型：" forKey:EnumToKey(XYOrderDetailCellTypeVIPType)];
        [_titleMap setValue:@"企业&高校：" forKey:EnumToKey(XYOrderDetailCellTypeVIPName)];
        [_titleMap setValue:@"联系地址：" forKey:EnumToKey(XYOrderDetailCellTypeAddress)];
        [_titleMap setValue:@"设备型号：" forKey:EnumToKey(XYOrderDetailCellTypeDevice)];
        [_titleMap setValue:@"设备颜色：" forKey:EnumToKey(XYOrderDetailCellTypeColor)];
        [_titleMap setValue:@"故障详情：" forKey:EnumToKey(XYOrderDetailCellTypeFault)];
        [_titleMap setValue:@"维修方案：" forKey:EnumToKey(XYOrderDetailCellTypePlan)];
        [_titleMap setValue:@"额外故障：" forKey:EnumToKey(XYOrderDetailCellTypeOtherFaults)];
        [_titleMap setValue:@"额外故障：" forKey:EnumToKey(XYOrderDetailCellTypeOtherFaults_noRecyle)];
        [_titleMap setValue:@"订单金额：" forKey:EnumToKey(XYOrderDetailCellTypeTotalPrice)];
        [_titleMap setValue:@"维修费用：" forKey:EnumToKey(XYOrderDetailCellTypeRepairPrice)];
        [_titleMap setValue:@"上门费用：" forKey:EnumToKey(XYOrderDetailCellTypeHomeServicePrice)];
        [_titleMap setValue:@"手工费用：" forKey:EnumToKey(XYOrderDetailCellTypeWorkerPrice)];
        [_titleMap setValue:@"保修状态：" forKey:EnumToKey(XYOrderDetailCellTypeGuarantee)];
        [_titleMap setValue:@"用户备注：" forKey:EnumToKey(XYOrderDetailCellTypeUserRemark)];
        [_titleMap setValue:@"内部备注：" forKey:EnumToKey(XYOrderDetailCellTypeInternalRemark)];
        [_titleMap setValue:@"设备号：" forKey:EnumToKey(XYOrderDetailCellTypeSerialNumber)];
        [_titleMap setValue:@"我的备注：" forKey:EnumToKey(XYOrderDetailCellTypeEngineerRemark)];
        [_titleMap setValue:@"交接状态：" forKey:EnumToKey(XYOrderDetailCellTypeSettleStatus)];
        [_titleMap setValue:@"支付流水号：" forKey:EnumToKey(XYOrderDetailCellTypeAlipaySerialNumber)];
        [_titleMap setValue:@"故障类型：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuFaults)];
        [_titleMap setValue:@"SN码：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuSNCode)];
        [_titleMap setValue:@"特权码：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuVIPCode)];
        [_titleMap setValue:@"额外故障：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuOtherFaults)];
        [_titleMap setValue:@"保修状态：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuGuarantee)];
        [_titleMap setValue:@"上门费用：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuHomeServicePrice)];
        [_titleMap setValue:@"维修费用：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuRepairPrice)];
        [_titleMap setValue:@"手工费用：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuWorkerPrice)];
        [_titleMap setValue:@"订单金额：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuTotalPrice)];
        [_titleMap setValue:@"用户备注：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuUserRemark)];
        [_titleMap setValue:@"内部备注：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuInternalRemark)];
        [_titleMap setValue:@"我的备注：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuEngineerRemark)];
        [_titleMap setValue:@"交接状态：" forKey:EnumToKey(XYOrderDetailCellTypeMeizuSettleStatus)];
        [_titleMap setValue:@"支付类型：" forKey:EnumToKey(XYOrderDetailCellTypePaymentName)];
    }
    if (self.orderDetail.status == XYOrderStatusPending || self.orderDetail.status == XYOrderStatusCancelled) {
        [_titleMap setValue:@"预约时间：" forKey:EnumToKey(XYOrderDetailCellTypeRepairTime)];
    }else{
        [_titleMap setValue:[self isBeforeRepairingDone]?@"预约时间：":@"维修时间：" forKey:EnumToKey(XYOrderDetailCellTypeRepairTime)];
    }
    return _titleMap;
}

- (NSMutableDictionary*)contentMap{
    if(!_contentMap){
       _contentMap = [[NSMutableDictionary alloc]init];
    }
    [_contentMap setValue:self.orderDetail.cancel_check_remark forKey:EnumToKey(XYOrderDetailCellTypeCancelRemark)];
    [_contentMap setValue:self.orderDetail.uName forKey:EnumToKey(XYOrderDetailCellTypeName)];
    [_contentMap setValue:self.orderDetail.uMobile forKey:EnumToKey(XYOrderDetailCellTypePhone)];
    [_contentMap setValue:self.orderDetail.address forKey:EnumToKey(XYOrderDetailCellTypeAddress)];
    [_contentMap setValue:self.orderDetail.isVip?@"VIP订单":@"普通订单" forKey:EnumToKey(XYOrderDetailCellTypeVIPType)];
    [_contentMap setValue:self.orderDetail.vip_name forKey:EnumToKey(XYOrderDetailCellTypeVIPName)];
    if (self.orderDetail.status == XYOrderStatusPending || self.orderDetail.status == XYOrderStatusCancelled) {
        [_contentMap setValue:self.orderDetail.repairTimeString forKey:EnumToKey(XYOrderDetailCellTypeRepairTime)];
    }else{
        [_contentMap setValue:[self isBeforeRepairingDone]?self.orderDetail.repairTimeString:self.orderDetail.finishTimeString forKey:EnumToKey(XYOrderDetailCellTypeRepairTime)];
    }
    [_contentMap setValue:self.orderDetail.MouldName forKey:EnumToKey(XYOrderDetailCellTypeDevice)];
    [_contentMap setValue:self.orderDetail.color forKey:EnumToKey(XYOrderDetailCellTypeColor)];
    [_contentMap setValue:self.orderDetail.FaultTypeDetail forKey:EnumToKey(XYOrderDetailCellTypeFault)];
    [_contentMap setValue:self.orderDetail.RepairType forKey:EnumToKey(XYOrderDetailCellTypePlan)];
    [_contentMap setValue:[NSString stringWithFormat:@"￥%@元",@(self.orderDetail.repairprice)] forKey:EnumToKey(XYOrderDetailCellTypeRepairPrice)];
    [_contentMap setValue:[NSString stringWithFormat:@"￥%@元",@(self.orderDetail.brand_home_visit_fee)] forKey:EnumToKey(XYOrderDetailCellTypeHomeServicePrice)];
    [_contentMap setValue:[NSString stringWithFormat:@"￥%@元",@(self.orderDetail.brand_manual_fee)] forKey:EnumToKey(XYOrderDetailCellTypeWorkerPrice)];
    [_contentMap setValue:self.orderDetail.remark forKey:EnumToKey(XYOrderDetailCellTypeUserRemark)];
    [_contentMap setValue:self.orderDetail.in_remark forKey:EnumToKey(XYOrderDetailCellTypeInternalRemark)];
    [_contentMap setValue:self.orderDetail.RepairNumber forKey:EnumToKey(XYOrderDetailCellTypeSerialNumber)];
    [_contentMap setValue:self.orderDetail.selfRemark forKey:EnumToKey(XYOrderDetailCellTypeEngineerRemark)];
    [_contentMap setValue:self.orderDetail.billTime>0.5?@"已结算":@"未结算" forKey:EnumToKey(XYOrderDetailCellTypeSettleStatus)];
    [_contentMap setValue:self.orderDetail.payment_name forKey:EnumToKey(XYOrderDetailCellTypePaymentName)];
    [_contentMap setValue:self.orderDetail.pay_sn forKey:EnumToKey(XYOrderDetailCellTypeAlipaySerialNumber)];
    
//魅族以下
    [_contentMap setValue:self.orderDetail.RepairNumber forKey:EnumToKey(XYOrderDetailCellTypeMeizuSNCode)];
    [_contentMap setValue:self.orderDetail.vip forKey:EnumToKey(XYOrderDetailCellTypeMeizuVIPCode)];
    [_contentMap setValue:[NSString stringWithFormat:@"保修期%@",(self.orderDetail.brand_warranty_status == XYGuarrantyStatusInGuarranty)?@"内":@"外"] forKey:EnumToKey(XYOrderDetailCellTypeMeizuGuarantee)];
    [_contentMap setValue:[NSString stringWithFormat:@"￥%@元",@(self.orderDetail.brand_home_visit_fee)] forKey:EnumToKey(XYOrderDetailCellTypeMeizuHomeServicePrice)];
    [_contentMap setValue:[NSString stringWithFormat:@"￥%@元",@(self.orderDetail.repairprice)] forKey:EnumToKey(XYOrderDetailCellTypeMeizuRepairPrice)];
    [_contentMap setValue:[NSString stringWithFormat:@"￥%@元",@(self.orderDetail.brand_manual_fee)] forKey:EnumToKey(XYOrderDetailCellTypeMeizuWorkerPrice)];
    [_contentMap setValue:self.orderDetail.remark forKey:EnumToKey(XYOrderDetailCellTypeMeizuUserRemark)];
    [_contentMap setValue:self.orderDetail.in_remark forKey:EnumToKey(XYOrderDetailCellTypeMeizuInternalRemark)];
    [_contentMap setValue:self.orderDetail.selfRemark forKey:EnumToKey(XYOrderDetailCellTypeMeizuEngineerRemark)];
    [_contentMap setValue:self.orderDetail.billTime>0.5?@"已结算":@"未结算" forKey:EnumToKey(XYOrderDetailCellTypeMeizuSettleStatus)];
    
//    [_contentMap setValue:self.orderDetail.payment_name forKey:EnumToKey(XYOrderDetailCellTypeMeizuPaymentName)];//支付类型，魅族未添加
    
    return _contentMap;
}

- (NSMutableDictionary*)cachedPhotoMap{
    if (!_cachedPhotoMap) {
        _cachedPhotoMap = [[NSMutableDictionary alloc]init];
    }
    return _cachedPhotoMap;
}

#pragma mark - booleans

- (BOOL)isMeizuOrder{//是否是魅族订单
    return (self.orderDetail.bid == XYBrandTypeMeizu);
}

- (BOOL)canScanQRCode{
    return (!self.orderDetail.payStatus)&& (self.orderDetail.status == XYOrderStatusRepaired); //1.未支付 2.维修完成后
}

- (BOOL)shouldShowOtherFaults{    
    //是否显示屏幕折旧相关信息 。。sb
    if(self.orderDetail.status == XYOrderStatusSubmitted){
        return false;//已预约状态 一定不显示
    }else if([self isBeforeRepairingDone]){
        //已出发和门店维修状态 用is_extra判断是否显示
      return self.orderDetail.is_extra;
    }else{
        //维修完成后 用allowExtraPrice判断是否显示
      return self.orderDetail.allowExtraPrice||self.orderDetail.allowExtraPrice_noRecyle;
    }
}

- (BOOL)isBeforeRepairingDone{
    XYOrderStatus status = self.orderDetail.status;
    return (status == XYOrderStatusPending || status == XYOrderStatusSubmitted || self.orderDetail.status == XYOrderStatusOnTheWay || self.orderDetail.status == XYOrderStatusShopRepairing || self.orderDetail.status == XYOrderStatusRepairing);
}

- (BOOL)shouldShowRepairSelections{
    if (![self isBeforeRepairingDone]) {
        //如果已经完成 必须显示
        return true;
    }else{
        //如果尚未完成 判断是否是售后单
        return (self.orderDetail.order_status == XYOrderTypeAfterSales);
    }
}

- (BOOL)hasCancelCheckRemark{//取消订单的审核备注
    return ![XYStringUtil isNullOrEmpty:self.orderDetail.cancel_check_remark];
}

- (BOOL)allPhotosTaken{
    if([self isMeizuOrder]){
        BOOL pic1Lack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic1] && ![self.cachedPhotoMap objectForKey:mz_photo_cell_devno_pic1];
        BOOL pic2Lack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic2] && ![self.cachedPhotoMap objectForKey:mz_photo_cell_devno_pic2];
        BOOL vipLack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic3] && ![self.cachedPhotoMap objectForKey:mz_photo_cell_devno_pic3];
        BOOL receiptLack = [XYStringUtil isNullOrEmpty:self.orderDetail.receipt_pic] && ![self.cachedPhotoMap objectForKey:mz_photo_cell_receipt_pic];
        
        if (self.orderDetail.isVip) {
            return !(pic1Lack || pic2Lack || vipLack || receiptLack);//缺少任意一张照片
        }else {
            return !(pic1Lack || pic2Lack || receiptLack );//缺少任意一张照片
        }
    }else{
        BOOL pic1Lack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic1] && ![self.cachedPhotoMap objectForKey:xy_photo_cell_devno_pic1];
        BOOL pic2Lack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic2] && ![self.cachedPhotoMap objectForKey:xy_photo_cell_devno_pic2];
        BOOL vipLack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic3] && ![self.cachedPhotoMap objectForKey:xy_photo_cell_devno_pic3];
        BOOL pic4Lack = [XYStringUtil isNullOrEmpty:self.orderDetail.devnopic4] && ![self.cachedPhotoMap objectForKey:xy_photo_cell_devno_pic4];
        if (self.orderDetail.isVip) {
            return !(pic1Lack || pic2Lack || vipLack || pic4Lack);//缺少任意一张照片
        }else {
            return !(pic1Lack || pic2Lack || pic4Lack);//缺少任意一张照片
        }
    }
}

#pragma mark - cells

- (NSInteger)numberOfSections{
    return 8; //0.顶栏 1.用户信息 2.机型信息 3.维修信息 4.保修信息 5.其他信息 6.付款码 7.评论
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case XYOrderDetailSectionTypeTop:
            return ([self hasCancelCheckRemark])?2:1;//取消订单审核
            break;
        case XYOrderDetailSectionTypeUserInfo:
            return self.orderDetail.isVip?6:4;
            break;
        case XYOrderDetailSectionTypeDeviceInfo:
            return 2;
            break;
        case XYOrderDetailSectionTypeRepairInfo:
        {
            if([self isMeizuOrder]){
                return self.shouldShowOtherFaults?4:3;//魅族单独显示多故障及sn,vip码
            }else{
                return self.shouldShowOtherFaults?4:2;//附加选项（满天星等）
            }
        }
            break;
        case XYOrderDetailSectionTypePricesAndGuarantee:
        {
            if([self isMeizuOrder]){
                return 5;//魅族的保修，上门，维修，手工，总价
            }else{
                return self.orderDetail.need_pay_status?6:2;//是否要显示保修状态（分项费用），
            }
        }
            break;
        case XYOrderDetailSectionTypeOthers:
            return [self isMeizuOrder]?4:7;
            break;
        case XYOrderDetailSectionTypeQRCode:
            return [self canScanQRCode]?1:0;//是否显示支付码
            break;
        case XYOrderDetailSectionTypeComment:
            return self.orderDetail.is_comment?1:0;//是否有评论
            break;
        default:
            break;
    }
    return 0;
}

- (BOOL)isSpecialMeizuSection:(NSIndexPath*)path{
    return path.section == XYOrderDetailSectionTypeRepairInfo || path.section == XYOrderDetailSectionTypePricesAndGuarantee || path.section == XYOrderDetailSectionTypeOthers;
}

- (XYOrderDetailCellType)getCellTypeByPath:(NSIndexPath*)path{
    if ([self isMeizuOrder] && [self isSpecialMeizuSection:path]) {
        //魅族 单独处理
        return (XYOrderDetailCellType)(path.section*100+path.row);
    }else{
        NSInteger tag = (path.section*10+path.row);
        return (XYOrderDetailCellType)tag;
    }
}

- (NSString*)getTitleByType:(XYOrderDetailCellType)type{
    NSString* key = EnumToKey(type);
    return self.titleMap[key];
}

- (NSString*)getContentByType:(XYOrderDetailCellType)type{
    NSString* key = EnumToKey(type);
    return self.contentMap[key];
}

- (BOOL)getInputableByType:(XYOrderDetailCellType)type{
    switch (type) {
        case XYOrderDetailCellTypeRepairTime://预约时间 只有已预约状态可改
            return (self.orderDetail.status == XYOrderStatusSubmitted);
        case XYOrderDetailCellTypeSerialNumber://只有已出发后状态可填写序列号。。。20161222
            return (self.orderDetail.status == XYOrderStatusOnTheWay || self.orderDetail.status == XYOrderStatusRepairing || self.orderDetail.status == XYOrderStatusShopRepairing);
        case XYOrderDetailCellTypeEngineerRemark:
        case XYOrderDetailCellTypeMeizuEngineerRemark:
            return [self isBeforeRepairingDone];//备注，未完成状态可改
        case XYOrderDetailCellTypeMeizuSNCode:
            return [XYStringUtil isNullOrEmpty:self.orderDetail.RepairNumber];//魅族code都是有了就不能改的。。
        case XYOrderDetailCellTypeMeizuVIPCode:
            return [XYStringUtil isNullOrEmpty:self.orderDetail.vip];//魅族code都是有了就不能改的。。
        default:
            break;
    }
    return false;
}

- (BOOL)getSelectableByType:(XYOrderDetailCellType)type{
    switch (type) {
        case XYOrderDetailCellTypeDevice:
        case XYOrderDetailCellTypePlan:
            return [self isBeforeRepairingDone];
            break;
        default:
            break;
    }
    return false;
}

#pragma mark - methods
- (void)loadOrderDetail:(NSString*)orderId bid:(XYBrandType)bid{
    [[XYAPIService shareInstance] getOrderDetail:orderId type:bid success:^(XYOrderDetail *order){
        if (order){
            self.orderDetail = order;
            [self.delegate onOrderDetailLoaded:true noteString:nil];
        }else{
            [self.delegate onOrderDetailLoaded:false noteString:TT_NO_ORDER_DETAIL];
        }
    }errorString:^(NSString *error){
        [self.delegate onOrderDetailLoaded:false noteString:error];
    }];
}

- (void)loadUserComment:(NSString*)orderId{
   [[XYAPIService shareInstance] getOrderComment:orderId bid:self.orderDetail.bid success:^(XYPHPCommentDto *cmDto){
       self.comment = cmDto;
       [self.delegate onOrderCommentLoaded:cmDto?true:false noteString:nil];
   }errorString:^(NSString *error){
       [self.delegate onOrderCommentLoaded:false noteString:error];
   }];
}

- (void)editDeviceSerialNumberInto:(NSString*)devNo{
    [[XYAPIService shareInstance]editDeviceSerialNumberInto:devNo ofOrder:self.orderDetail.id bid:self.orderDetail.bid success:^{
        self.orderDetail.RepairNumber = devNo;
        [self.delegate onDeviceSerialNumberEdited:true noteString:nil];
    }errorString:^(NSString *error){
        [self.delegate onDeviceSerialNumberEdited:false noteString:error];
    }];
}

- (void)editVipCodeInto:(NSString*)vip{
    [[XYAPIService shareInstance]editVIPCodeInto:vip ofOrder:self.orderDetail.id bid:self.orderDetail.bid success:^{
        self.orderDetail.vip = vip;
        [self.delegate onVIPCodeEdited:true noteString:nil];
    }errorString:^(NSString *error){
        [self.delegate onVIPCodeEdited:false noteString:error];
    }];
}

- (void)editRepairOrderedTime:(NSString*)reservetime reservetime2:(NSString *)reservetime2{

    [[XYAPIService shareInstance]editOrderTime:self.orderDetail.id newTime:reservetime reservetime2:reservetime2 bid:self.orderDetail.bid success:^{
        self.orderDetail.reserveTime = reservetime;
        self.orderDetail.reserveTime2 = reservetime2;
        self.orderDetail.repairTimeString = nil;
        [self.delegate onPreOrderTimeEdited:true noteString:nil];}
    errorString:^(NSString *error){
        [self.delegate onPreOrderTimeEdited:false noteString:error];
    }];
}

- (void)editRepairPlanInto:(NSString*)planid device:(NSString*)mouldId color:(NSString *)color{
    [[XYAPIService shareInstance]editRepairingPlanOfOrder:self.orderDetail.id newPlanId:planid mouldId:mouldId color:color bid:self.orderDetail.bid success:^{
        [self.delegate onRepairPlanEdited:true noteString:nil];
    }errorString:^(NSString *error){
         [self.delegate onRepairPlanEdited:false noteString:error];
    }];
}

- (void)turnStateOfOrderInto:(XYOrderStatus)status{
    switch (status) {
        case XYOrderStatusRepaired:
            //维修完成 有额外参数
            //改在新页面处理了，废弃
            break;
        case XYOrderStatusOnTheWay:
        {   //出发 要定位
            [[XYLocationManagerWithTimer sharedManager].locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                [[XYAPIService shareInstance] setOutOrder:self.orderDetail.id bid:self.orderDetail.bid address:regeocode.formattedAddress lat:[NSString stringWithFormat:@"%@",@(location.coordinate.latitude)] lng:[NSString stringWithFormat:@"%@",@(location.coordinate.longitude)] success:^{
                     [self.delegate onOrderStatusChangedInto:status];
                } errorString:^(NSString *error) {
                    [self.delegate onOrderStatusChangingFailed:error];
                }];
            }];
        }
            break;
        default://普通情况
        {
            [[XYAPIService shareInstance] changeStatusOfOrder:self.orderDetail.id into:status bid:self.orderDetail.bid success:^{
                [self.delegate onOrderStatusChangedInto:status];
            }errorString:^(NSString *error){
                [self.delegate onOrderStatusChangingFailed:error];
            }];
        }
            break;
    }
}

- (void)payOrderByCash{
    [[XYAPIService shareInstance] payOrderByCash:self.orderDetail.id bid:self.orderDetail.bid success:^{
         [self resetOrderInfoOnPaidByCash];
         [self.delegate onOrderPaidByCash:true noteString:nil];
     }errorString:^(NSString *error){
         [self.delegate onOrderPaidByCash:false noteString:error];
     }];
}

- (void)getPayCode:(XYQRCodePayType)type{
    NSInteger requestId = [[XYAPIService shareInstance] payByService:type order:self.orderDetail.id bid:self.orderDetail.bid success:^(NSString *imgUrl,NSString *price) {
        [self.delegate onPayQRCodeLoaded:true type:type code:imgUrl price:price noteString:nil];
    } errorString:^(NSString *error) {
        [self.delegate onPayQRCodeLoaded:false type:type code:nil price:nil noteString:error];
    }];
    [self registerRequestId:@(requestId)];
}

- (void)editRemarkInto:(NSString*)str{
    NSInteger requestId = [[XYAPIService shareInstance] editOrderRemark:self.orderDetail.id remark:str bid:self.orderDetail.bid success:^{
        self.orderDetail.selfRemark = str;
        [self.delegate onRemarkEdited:true noteString:nil];
    }errorString:^(NSString *error){
        [self.delegate onRemarkEdited:false noteString:error];
    }];
    [self registerRequestId:@(requestId)];
}

- (void)editGuarranteeInto:(XYGuarrantyStatus)status{
    [[XYAPIService shareInstance] changeGuarranteeStatusOfOrder:self.orderDetail.id into:status success:^{
        self.orderDetail.brand_warranty_status = status;
        [self loadOrderDetail:self.orderDetail.id bid:self.orderDetail.bid];//修改成功，重新拿订单详情
    }errorString:^(NSString *error){
        [self.delegate onGuarranteeEdited:false noteString:error];//失败，return
    }];
}

- (void)addOrDeleteRepairPlan:(NSString*)planId device:(NSString*)deviceId color:(NSString*)colorId isAddOrDelete:(BOOL)isAdd{
    NSArray* plans = [self.orderDetail.rp_id componentsSeparatedByString:@","];
    NSMutableArray* newPlans = [[NSMutableArray alloc]initWithArray:plans];
    //如果没有修改机型，分两种情况
    if ([XYStringUtil isNullOrEmpty:deviceId] || [deviceId isEqualToString:self.orderDetail.moudleid]) {
        if (isAdd) {//添加故障
            for (NSString* pid in newPlans) {//检查是否已存在
                if ([pid isEqualToString:planId]) {
                    [self.delegate onRepairPlanEdited:false noteString:@"维修方案已存在！"];
                    return;
                }
            }
            //不存在则，添加之
            [newPlans addObject:planId];
        }else{//删除故障
            if([newPlans count] <= 1){//如果只剩下一个了 不让删
                [self.delegate onRepairPlanEdited:false noteString:@"维修方案不可为空！"];
                return;
            }
            [newPlans removeObject:planId];
        }
    }else{
        //如果修改了机型，就一个plan即可
        [newPlans addObject:planId];
    }
    
    [[XYAPIService shareInstance]editMeizuPlansOfOrder:self.orderDetail.id plans:[newPlans componentsJoinedByString:@","] device:deviceId color:colorId success:^{
        [self.delegate onRepairPlanEdited:true noteString:nil];
    } errorString:^(NSString *error) {
        [self.delegate onRepairPlanEdited:false noteString:error];
    }];
}

- (void)resetOrderInfoOnPaidByCash{
    NSString* ppStr = self.orderDetail.priceAndPay.string;
    if (!ppStr.length) {
        return;
    }
    NSRange range = [ppStr rangeOfString:@"未"];
    NSMutableAttributedString* mtAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:self.orderDetail.priceAndPay];
    [mtAttributedString replaceCharactersInRange:range withString:@"现金"];
    [mtAttributedString addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR range:range];
    self.orderDetail.priceAndPay = mtAttributedString;
    self.orderDetail.payStatus = true;
    self.orderDetail.payment = XYPaymentTypePaidByCash;
    self.orderDetail.status = XYOrderStatusDone;
    self.orderDetail.rightUtilityButtons = nil;
}
#warning how
- (void)checkPaymentStatusRepeatedly{//重复检查支付状态
//    if ([self canScanQRCode]) {
//        [[XYAPIService shareInstance] getOrderDetail:self.orderDetail.id type:self.orderDetail.bid success:^(XYOrderDetail *order){
//            if (order && order.payStatus){
//                self.orderDetail = order;
//                [self.delegate onOrderDetailLoaded:true noteString:nil];
//            }else{
//                [self performSelector:@selector(checkPaymentStatusRepeatedly) withObject:nil afterDelay:5];
//            }
//        }errorString:^(NSString *error){
//            [self performSelector:@selector(checkPaymentStatusRepeatedly) withObject:nil afterDelay:5];
//        }];
//    }
}

- (BOOL)getPhotoTakingAvailable{
    ALAuthorizationStatus albumAuthor = [ALAssetsLibrary authorizationStatus];
    if (albumAuthor == ALAuthorizationStatusRestricted || albumAuthor == ALAuthorizationStatusDenied){
        return false;
    }
    return true;
}

- (BOOL)getPhotoSavingAvailable{
    AVAuthorizationStatus photoAuthor = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (photoAuthor == AVAuthorizationStatusRestricted || photoAuthor ==AVAuthorizationStatusDenied){
        return false;
    }
    return true;
}

//同步（在点击“维修完成”前上传完毕）上传图片的方法，由于需求都改为了允许异步上传，故废弃
//- (void)uploadDeviceNoImage:(NSData*)imgData forPropertyName:(NSString*)name{
//    //传图
//    [[XYAPIService shareInstance]uploadImage:imgData type:XYPictureTypeRepairNumber parameters:@{@"user_name":XY_NOTNULL(self.orderDetail.uName, [XYAPPSingleton sharedInstance].currentUser.Name)} success:^(NSString *url){
//        //保存原始图片
//        NSString* preUrl = [[self.orderDetail valueForKey:name]copy];
//        //替换为当前上传图片
//        [self.orderDetail setValue:url forKey:name];
//        //关联订单号
//        [[XYAPIService shareInstance]editRepairOrder:self.orderDetail.id bid:self.orderDetail.bid photo1:self.orderDetail.devnopic1 photo2:self.orderDetail.devnopic2 success:^{
//            [self.delegate onPhotosEdited:true url:url photoName:name noteString:nil];
//        } errorString:^(NSString *err) {
//            //关联失败，复原为原始图片
//            [self.orderDetail setValue:preUrl forKey:name];
//            [self.delegate onPhotosEdited:false url:nil photoName:name noteString:err];
//        }];
//    } errorString:^(NSString *error) {
//        [self.delegate onPhotosEdited:false url:nil photoName:name noteString:error];
//    }];
//}
//
//- (void)uploadReceiptImage:(NSData *)imgData{
//    //传图
//    [[XYAPIService shareInstance]uploadImage:imgData type:XYPictureTypeReceipt parameters:@{@"user_name":XY_NOTNULL(self.orderDetail.uName, [XYAPPSingleton sharedInstance].currentUser.Name)} success:^(NSString *url){
//        //保存原始图片
//        NSString* preUrl = [self.orderDetail.receipt_pic copy];
//        //替换为当前上传图片
//        self.orderDetail.receipt_pic = url;
//        //关联订单号
//        [[XYAPIService shareInstance]editReceiptOfOrder:self.orderDetail.id bid:self.orderDetail.bid url:url success:^{
//            [self.delegate onPhotosEdited:true url:url photoName:@"receipt_pic" noteString:nil];
//        } errorString:^(NSString *err) {
//            //关联失败，复原为原始图片
//            self.orderDetail.receipt_pic = preUrl;
//            [self.delegate onPhotosEdited:false url:nil photoName:@"receipt_pic" noteString:err];
//        }];
//    } errorString:^(NSString *error) {
//        [self.delegate onPhotosEdited:false url:nil photoName:@"receipt_pic" noteString:error];
//    }];
//}

- (void)uploadAsynPhoto:(NSData*)imgData type:(XYPictureType)type repeatCount:(NSInteger)count orderId:(NSString*)orderId bid:(XYBrandType)bid name:(NSString*)name onSuccess:(void (^)(NSString*))onSuccess onFailure:(void (^)())onFailure{
    
    if(type == XYPictureTypeSelfPhotoTaking){
        self.hasTakenSelfPhoto = true; //标记为自拍已传
    }
    
    //不管成功与否，一切在后台操作
    if (!imgData.length) {
        return;
    }
    
    [[XYOrderListManager sharedInstance]uploadAsynImage:imgData bid:bid type:type order:orderId property:name?name:@"unknown" result:^(BOOL success, NSString* url) {
            if (!success) {
                if(imgData.length){
                    if ([UIImage imageWithData:imgData]) {
                        [self.cachedPhotoMap setObject:[UIImage imageWithData:imgData] forKey:name];
                        [[XYOrderListManager sharedInstance] saveImageToAlbum:imgData forOrder:orderId bid:bid type:type property:name];
                    }
                }
                onFailure(onFailure);
            }else{
                switch (type) {
                    case XYPictureTypeRepairNumber:
                        [self.orderDetail setValue:url forKey:name];
                        break;
                    case XYPictureTypeReceipt:
                        self.orderDetail.receipt_pic = url;
                        break;
                    default:
                        break;
                }
                onSuccess(url);
            }
    }];
}

@end
