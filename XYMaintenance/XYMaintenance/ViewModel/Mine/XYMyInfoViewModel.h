//
//  XYMyInfoViewModel.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/9.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"


typedef NS_ENUM(NSInteger, XYMyInfoCellType) {
    XYMyInfoCellTypeSectionTitlePersonalInfo = 0,//分区标题“个人信息”
    XYMyInfoCellTypeName = 1,
    XYMyInfoCellTypeWorkerId = 2,
    XYMyInfoCellTypeDeposit = 3,
    XYMyInfoCellTypeStar = 4,
    XYMyInfoCellTypeSectionTitleBusinessInfo = 10,//分区标题“业务信息”
    XYMyInfoCellTypeLevel = 11,
    XYMyInfoCellTypeRepairType = 12,
    XYMyInfoCellTypeUseLimit = 13,
    XYMyInfoCellTypeCity = 14,
    XYMyInfoCellTypeDistricts = 15,
    XYMyInfoCellTypeTowns = 16,
    XYMyInfoCellTypeSectionTitleOrdersInfo = 20,//分区标题“接单信息”
    XYMyInfoCellTypeWithdrawCount = 21,
    XYMyInfoCellTypeMonthComplete = 22,
    XYMyInfoCellTypeAfterSaleCount = 23,
    XYMyInfoCellTypeAfterSaleRatio = 24,
    XYMyInfoCellTypeOvertimeCount = 25,
};

@interface XYMyInfoViewModel : XYBaseViewModel

@property(strong,nonatomic)XYUserDetail* userDetail;
@property(strong,nonatomic)NSMutableDictionary* titleMap;
@property(strong,nonatomic)NSMutableDictionary* contentMap;

- (void)setInfoDetail:(XYUserDetail*)userDetail;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (XYMyInfoCellType)getCellTypeByPath:(NSIndexPath*)path;
- (NSString*)getTitleByType:(XYMyInfoCellType)type;
- (NSString*)getContentByType:(XYMyInfoCellType)type;
- (BOOL)getSelectableByType:(XYMyInfoCellType)type;

@end
