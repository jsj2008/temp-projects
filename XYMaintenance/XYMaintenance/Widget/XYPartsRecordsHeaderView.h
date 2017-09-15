//
//  XYPartsRecordsHeaderView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/11/21.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYPartsFlowTimeType){
    XYPartsFlowTimeTypeStart =  1,    //开始
    XYPartsFlowTimeTypeEnd = 2 , //结束
    XYPartsFlowTimeTypeStart_partApplyLog =  3,    //开始 配件申请日志
    XYPartsFlowTimeTypeEnd_partApplyLog = 4 , //结束 配件申请日志
};

@protocol XYPartsFlowSearchDelegate <NSObject>
- (void)selectDate:(NSString*)dateStr type:(XYPartsFlowTimeType)type ;
- (void)selectPart;
- (void)doSearchPartsFlow;
- (void)doSearchPartsApplyLog;
@end

@interface XYPartsRecordsHeaderView : UIView
@property (assign,nonatomic) id<XYPartsFlowSearchDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UITextField *partField;
+ (XYPartsRecordsHeaderView*)recordsHeaderView;
+ (XYPartsRecordsHeaderView*)filtertimeView;
@end
