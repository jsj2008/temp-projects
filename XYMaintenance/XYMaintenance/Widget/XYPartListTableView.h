//
//  XYPartListTableView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/23.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYBaseTableView.h"
#import "XYPartDto.h"

@protocol XYPartListTableViewDelegate <NSObject>
-(void)confirmClaimRecord:(NSString*)record bid:(XYBrandType)bid;
-(void)goToClaimRecordDetail:(XYPartRecordDto*)recordId;
-(void)goToApplyRecordVc:(XYPartsApplyLogDto*)partsApplyLogDto;
@end

typedef NS_ENUM(NSInteger, XYPartListViewType) {
    XYPartListViewTypeUnknown = -1,
    XYPartListViewTypeMyParts = 0,
    XYPartListViewTypeClaimRecords = 1,
    XYPartListViewTypePartsFlow = 2,
    XYPartListViewTypePartsApplyLog = 3,
};

@interface XYPartListTableView : XYBaseTableView<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)id<XYPartListTableViewDelegate> partListViewDelegate;
@property(assign,nonatomic)XYPartListViewType type;
@end
