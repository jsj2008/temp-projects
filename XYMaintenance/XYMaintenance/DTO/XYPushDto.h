//
//  XYPushDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/5/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYAPPDto.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//推送类型
typedef NS_ENUM(NSInteger, XYPushNotificationType) {
    XYPushNotificationTypeUnknown = -1,
    XYPushNotificationTypeNewOrder = 1,    //new_order新的可接订单
    XYPushNotificationTypeNewNotice = 2,    //new_notice新公告
    XYPushNotificationTypeCancelReply = 3,    //new_engineer_kill_order 撤单回复
    XYPushNotificationTypeUserCancel = 4, //new_user_kill_order订单取消
    XYPushNotificationTypeRemindGo = 5, //new_go_on 提醒出发
    XYPushNotificationTypeAssignOrder = 6, //new_receive_order 派单
    
    XYPushNotificationTypeOrderTransferred = 7,//order_transfered 转单
    XYPushNotificationTypeClaimParts = 8,//has_new_parts 领配件
    XYPushNotificationTypeEditTime = 9, //change_reservetime 修改预约时间
    XYPushNotificationTypeLeaveApproved = 10,//leave_result 请假审批
};

/**
 * 音效文件名定义
 */
//extern NSString *const XYNotificationSoundNewOrder;
//extern NSString *const XYNotificationSoundNewNotice;
//extern NSString *const XYNotificationSoundCancelReply;
//extern NSString *const XYNotificationSoundUserCancel;
//extern NSString *const XYNotificationSoundRemindGo;
//extern NSString *const XYNotificationSoundAssignOrder;
//extern NSString *const XYNotificationSoundOrderTransferred;
//extern NSString *const XYNotificationSoundClaimParts;
//extern NSString *const XYNotificationSoundEditTime;
//extern NSString *const XYNotificationSoundLeaveApproved;

extern NSString *const XYNotificationSoundOrderSuccess;
extern NSString *const XYNotificationSoundOrderFail;
extern NSString *const XYNotificationActionCategoryAcceptOrder;
extern NSString *const XYNotificationActionActionAcceptOrder;

@class XYOrderMessageDto;

@interface XYPushDto : NSObject

+ (XYPushNotificationType)getTypeByUserInfo:(NSDictionary*)dic;
+ (NSString*)getSoundFileByType:(XYPushNotificationType)type;
+ (void)playSoundByName:(NSString*)name;


/**
 *  快速接单类别
 */
+ (UNNotificationCategory*)createiOS10OrderCategory;
+ (UIMutableUserNotificationCategory*)createOrderCategory;

/**
 *  本地通知
 */
+ (void)sendLocalNotification:(NSString*)body sound:(NSString*)soundName;

//通过通知界面直接接单
+ (void)acceptOrder:(NSString*)orderId bid:(XYBrandType)bid withCompletionHandler:(void (^)())completionHandler;

/**
 *  快捷接单也要发短信
 */
+ (void)requestMessageSendingTo:(XYOrderMessageDto*)order;

@end
