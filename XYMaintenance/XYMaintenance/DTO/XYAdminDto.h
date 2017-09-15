//
//  XYAdminDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/7.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDtoContainer.h"

typedef NS_ENUM(NSInteger, XYWorkerStatus) {
    XYWorkerStatusOffWork = 0,    //下班
    XYWorkerStatusWorking = 1,    //上班
    XYWorkerStatusHangUp = 2,    //挂起
    XYWorkerStatusRepairing = 3,  //维修中
    XYWorkerStatusInvalid = 4,  //封停
};

typedef NS_ENUM(NSInteger, XYCancelReasonType) {
    XYCancelReasonTypeUser = 1,    //用户原因
    XYCancelReasonTypeWorker = 2,    //工程师原因
    XYCancelReasonTypeOther = 3,    //其它原因
};


@interface XYWorkerStatusDto : NSObject
@property (nonatomic,copy) NSString* Id;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,assign) XYWorkerStatus status;
@property (nonatomic,copy) NSString* online_at;

@property (nonatomic,copy) NSString* statusStr;
@property (nonatomic,strong) NSDate* onlineDate;
@property (nonatomic,copy) NSString* onlineTimeStr;
@property (assign,nonatomic) BOOL isToday;//上班时间是不是今天的

@end

@interface XYNewsDto : NSObject
@property (nonatomic,copy)NSString* id;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* create_at;
@property (nonatomic,copy)NSString* link;
@property (nonatomic,assign)NSInteger view_count;
@property (nonatomic,assign)BOOL is_top;
@property (nonatomic,assign)XYBrandType bid;
@property (nonatomic,copy) NSString* dateString;
//@property (nonatomic,assign) BOOL isNew;

@end

@interface XYNewsSortDto : NSObject
@property (nonatomic,copy)NSString* Id;
@property (nonatomic,copy)NSString* name;
@property (nonatomic,assign)BOOL isNew;//这个分类下是否存在没有看过的公告(新添加的)

@end

@interface XYReasonDto :NSObject
@property (nonatomic,copy)NSString* Id;
@property (nonatomic,copy)NSString* name;
@property (nonatomic,assign)XYCancelReasonType type;
@end
