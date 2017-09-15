//
//  XYMyInfoViewModel.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/9.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYMyInfoViewModel.h"

@implementation XYMyInfoViewModel

- (NSMutableDictionary*)titleMap{
    if (!_titleMap) {
        _titleMap = [[NSMutableDictionary alloc]init];
        [_titleMap setValue:@"个人信息" forKey:EnumToKey(XYMyInfoCellTypeSectionTitlePersonalInfo)];
        [_titleMap setValue:@"业务信息" forKey:EnumToKey(XYMyInfoCellTypeSectionTitleBusinessInfo)];
        [_titleMap setValue:@"接单信息" forKey:EnumToKey(XYMyInfoCellTypeSectionTitleOrdersInfo)];
        [_titleMap setValue:@"姓名" forKey:EnumToKey(XYMyInfoCellTypeName)];
        [_titleMap setValue:@"工号" forKey:EnumToKey(XYMyInfoCellTypeWorkerId)];
        [_titleMap setValue:@"基数" forKey:EnumToKey(XYMyInfoCellTypeDeposit)];
        [_titleMap setValue:@"星级" forKey:EnumToKey(XYMyInfoCellTypeStar)];
        [_titleMap setValue:@"工程师等级" forKey:EnumToKey(XYMyInfoCellTypeLevel)];
        [_titleMap setValue:@"可维修类型" forKey:EnumToKey(XYMyInfoCellTypeRepairType)];
        [_titleMap setValue:@"领用额度" forKey:EnumToKey(XYMyInfoCellTypeUseLimit)];
        [_titleMap setValue:@"接单城市" forKey:EnumToKey(XYMyInfoCellTypeCity)];
        [_titleMap setValue:@"上门区域" forKey:EnumToKey(XYMyInfoCellTypeDistricts)];
        [_titleMap setValue:@"下属乡镇" forKey:EnumToKey(XYMyInfoCellTypeTowns)];
        [_titleMap setValue:@"撤单率" forKey:EnumToKey(XYMyInfoCellTypeWithdrawCount)];
        [_titleMap setValue:@"本月/总售后单量" forKey:EnumToKey(XYMyInfoCellTypeAfterSaleCount)];
        [_titleMap setValue:@"售后单比例" forKey:EnumToKey(XYMyInfoCellTypeAfterSaleRatio)];
        [_titleMap setValue:@"本月完成单数" forKey:EnumToKey(XYMyInfoCellTypeMonthComplete)];
        [_titleMap setValue:@"本月/总超时订单量" forKey:EnumToKey(XYMyInfoCellTypeOvertimeCount)];
    }
    return _titleMap;
}

- (NSMutableDictionary*)contentMap{
    if(!_contentMap){
        _contentMap = [[NSMutableDictionary alloc]init];
        [_contentMap setValue:self.userDetail.realName forKey:EnumToKey(XYMyInfoCellTypeName)];
        [_contentMap setValue:self.userDetail.Name forKey:EnumToKey(XYMyInfoCellTypeWorkerId)];
        [_contentMap setValue:self.userDetail.foregift forKey:EnumToKey(XYMyInfoCellTypeDeposit)];
        [_contentMap setValue:self.userDetail.level_info.level_name forKey:EnumToKey(XYMyInfoCellTypeLevel)];
        [_contentMap setValue:self.userDetail.service_type forKey:EnumToKey(XYMyInfoCellTypeRepairType)];
        [_contentMap setValue:self.userDetail.use_limit forKey:EnumToKey(XYMyInfoCellTypeUseLimit)];
        [_contentMap setValue:self.userDetail.city_name forKey:EnumToKey(XYMyInfoCellTypeCity)];
        [_contentMap setValue:self.userDetail.eng_region forKey:EnumToKey(XYMyInfoCellTypeDistricts)];
         [_contentMap setValue:self.userDetail.townsString forKey:EnumToKey(XYMyInfoCellTypeTowns)];
        [_contentMap setValue:[NSString stringWithFormat:@"%@%%",self.userDetail.total_cancel_percent] forKey:EnumToKey(XYMyInfoCellTypeWithdrawCount)];
        [_contentMap setValue:[NSString stringWithFormat:@"%@/%@",self.userDetail.total_month_after_sale,self.userDetail.total_after_sale] forKey:EnumToKey(XYMyInfoCellTypeAfterSaleCount)];
        [_contentMap setValue:[NSString stringWithFormat:@"%@%%",self.userDetail.after_sale_percent] forKey:EnumToKey(XYMyInfoCellTypeAfterSaleRatio)];
        [_contentMap setValue:self.userDetail.total_month_payed forKey:EnumToKey(XYMyInfoCellTypeMonthComplete)];
        [_contentMap setValue:[NSString stringWithFormat:@"%@/%@",self.userDetail.total_current_month_timeout_orders,self.userDetail.total_timeout_orders] forKey:EnumToKey(XYMyInfoCellTypeOvertimeCount)];
    }
    return _contentMap;
}

- (void)setInfoDetail:(XYUserDetail*)userDetail{
    self.userDetail = userDetail;
    self.contentMap = nil;
}

- (NSInteger)numberOfSections{
    return 3;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 6;
            break;
        default:
            return 0;
            break;
    }
}

- (XYMyInfoCellType)getCellTypeByPath:(NSIndexPath*)path{
    NSInteger tag = (path.section*10+path.row);
    return (XYMyInfoCellType)tag;
}

- (NSString*)getTitleByType:(XYMyInfoCellType)type{
    NSString* key = EnumToKey(type);
    return self.titleMap[key];
}

- (NSString*)getContentByType:(XYMyInfoCellType)type{
    NSString* key = EnumToKey(type);
    return self.contentMap[key];
}

- (BOOL)getSelectableByType:(XYMyInfoCellType)type{
    return false;//第一版不做跳转
}

@end
