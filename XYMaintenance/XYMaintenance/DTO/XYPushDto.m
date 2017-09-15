//
//  XYPushDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPushDto.h"
#import "XYOrderDto.h"
#import "XYStringUtil.h"
#import "XYHttpClient.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XYAPPSingleton.h"
#import "API.h"


static SystemSoundID shake_sound_male_id = 8888;

//NSString *const XYNotificationSoundNewOrder = @"new_order";
//NSString *const XYNotificationSoundNewNotice = @"new_notice";
//NSString *const XYNotificationSoundCancelReply = @"new_engineer_kill_order";
//NSString *const XYNotificationSoundUserCancel = @"new_user_kill_order";
//NSString *const XYNotificationSoundRemindGo = @"new_go_on";
//NSString *const XYNotificationSoundAssignOrder = @"new_receive_order";
//NSString *const XYNotificationSoundOrderTransferred = @"order_transfered";
//NSString *const XYNotificationSoundClaimParts = @"has_new_parts";
//NSString *const XYNotificationSoundEditTime = @"change_reservetime";
//NSString *const XYNotificationSoundLeaveApproved = @"leave_result";

NSString *const XYNotificationSoundOrderSuccess = @"order_success.wav";
NSString *const XYNotificationSoundOrderFail = @"order_fail.wav";

NSString *const XYNotificationActionCategoryAcceptOrder = @"order1";
NSString *const XYNotificationActionActionAcceptOrder = @"orderAction";

//static NSArray *typesArray;

@interface XYPushDto()

@end

@implementation XYPushDto

+ (NSArray *)getTypesArr
{
    static NSArray *typesArr;
    if (!typesArr) {
        typesArr = @[@"new_order",
                     @"new_notice",
                     @"new_engineer_kill_order",
                     @"new_user_kill_order",
                     @"new_go_on",
                     @"new_receive_order",
                     @"order_transfered",
                     @"has_new_parts",
                     @"change_reservetime",
                     @"leave_result"];
    }
    return typesArr;
}

+ (XYPushNotificationType)getTypeByUserInfo:(NSDictionary*)userInfo{
    
    if (!userInfo) {
        return XYPushNotificationTypeUnknown;
    }

    NSArray *types = [self getTypesArr];
    for (NSInteger i = 0; i < [types count]; i++) {
        if ([userInfo[@"type"] isEqualToString:types[i]]) {
            return (XYPushNotificationType)(i+1);
        }
        
    }
    return XYPushNotificationTypeUnknown;
}

+ (NSString*)getSoundFileByType:(XYPushNotificationType)type{
    
    NSArray *types = [self getTypesArr];
    if (type >= 0 && type < types.count) {
        return types[type-1];
    }
    
    return @"default";
}

//    
//    switch (type) {
//        case XYPushNotificationTypeNewOrder:
//            return XYNotificationSoundNewOrder;
//            break;
//        case XYPushNotificationTypeNewNotice:
//            return XYNotificationSoundNewNotice;
//            break;
//        case XYPushNotificationTypeCancelReply:
//            return XYNotificationSoundCancelReply;
//            break;
//        case XYPushNotificationTypeUserCancel:
//            return XYNotificationSoundUserCancel;
//            break;
//        case XYPushNotificationTypeRemindGo:
//            return XYNotificationSoundRemindGo;
//            break;
//        case XYPushNotificationTypeAssignOrder:
//            return XYNotificationSoundAssignOrder;
//            break;
//        case XYPushNotificationTypeOrderTransferred:
//            return XYNotificationSoundOrderTransferred;
//        case XYPushNotificationTypeClaimParts:
//            return XYNotificationSoundClaimParts;
//        case XYPushNotificationTypeEditTime:
//            return XYNotificationSoundEditTime;
//        case XYPushNotificationTypeLeaveApproved:
//            return XYNotificationSoundLeaveApproved;
//        default:
//            break;
//    }
   


+ (void)playSoundByName:(NSString *)name{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    if (path) {
       //注册声音到系统
       AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
       AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//zhendong
       AudioServicesPlaySystemSound(shake_sound_male_id);//播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    }
}

+ (UNNotificationCategory*)createiOS10OrderCategory{
    UNNotificationAction* orderAction = [UNNotificationAction actionWithIdentifier:@"orderAction" title:@"接单" options:UNNotificationActionOptionForeground];
    UNNotificationCategory *categorys = [UNNotificationCategory categoryWithIdentifier:XYNotificationActionCategoryAcceptOrder actions:@[orderAction]  intentIdentifiers:@[@"orderAction"] options:UNNotificationCategoryOptionCustomDismissAction];
    return categorys;
}

+ (UIMutableUserNotificationCategory*)createOrderCategory{
    //接单按钮
    UIMutableUserNotificationAction *orderAction = [[UIMutableUserNotificationAction alloc] init];
    orderAction.identifier = @"orderAction";
    orderAction.title = @"接单";
    orderAction.activationMode = UIUserNotificationActivationModeBackground;
    orderAction.authenticationRequired = NO;
    //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    orderAction.destructive = YES;
    
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = XYNotificationActionCategoryAcceptOrder;
    NSArray *actions = @[orderAction];
    [categorys setActions:actions forContext:UIUserNotificationActionContextMinimal];
    
    return categorys;
}

+ (void)sendLocalNotification:(NSString*)body sound:(NSString*)soundName{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //请求获取通知权限（角标，声音，弹框）
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取用户是否同意开启通知
                NSLog(@"request authorization successed!");
            }
        }];
        //第二步：新建通知内容对象
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = body;
        content.badge = @1;
        UNNotificationSound *sound = [UNNotificationSound soundNamed:soundName];
        content.sound = sound;
        //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
        UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
        //第四步：创建UNNotificationRequest通知请求对象
        NSString *requertIdentifier = soundName;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
        //第五步：将通知加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error:%@",error);
        }];
#endif
    }else{
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        notification.fireDate = fireDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        // 通知内容
        notification.alertBody = body;
        notification.applicationIconBadgeNumber = 1;
        // 通知被触发时播放的声音
        notification.soundName = soundName?soundName:UILocalNotificationDefaultSoundName;
        
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

//       if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//          UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//          UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
//          [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//       }
//          // 通知重复提示的单位，可以是天、周、月
//          notification.repeatInterval = 0;
//       } else {
//        // 通知重复提示的单位，可以是天、周、月
//          notification.repeatInterval = 0;
//       }


//        // 通知参数
//        NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"lalala" forKey:@"key"];
//        notification.userInfo = userDict;

//        // ios8后，需要添加这个注册，才能得到授权

+ (void)acceptOrder:(NSString*)orderId bid:(XYBrandType)bid withCompletionHandler:(void (^)())completionHandler{
    //注意一下死机状态先loadticket
    if (![XYAPPSingleton sharedInstance].currentCookie) {
        [[XYAPPSingleton sharedInstance] loadCachedData];
    }
    
    [[XYAPIService shareInstance]acceptOrder:orderId bid:bid success:^(XYOrderMessageDto *message,NSString* toast) {
        [XYPushDto sendLocalNotification:[NSString stringWithFormat:@"订单号：%@ 接单成功，请查看详情！",orderId] sound:XYNotificationSoundOrderSuccess];
        [XYPushDto requestMessageSendingTo:message];
        [[NSNotificationCenter defaultCenter] postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER_MAP object:nil];
        completionHandler();
    } errorString:^(NSString *err) {
        [XYPushDto sendLocalNotification:[NSString stringWithFormat:@"订单号：%@ 接单失败！%@",orderId,err] sound:XYNotificationSoundOrderFail];
        completionHandler();
    }];
}

+ (void)requestMessageSendingTo:(XYOrderMessageDto*)order{
    //服务端@chenr拒绝编写私钥签名代码 Orz
    NSString* key = @"5b46fc265b786a1b5edcf59d6ee06786";
    NSString *msgStr = [NSString stringWithFormat:@"phoneNum%@msgType2orderCode%@engCode%@",order.u_mobile,order.order_id,order.engineer_id];
    NSString* signStr = [XYStringUtil md5String:[NSString stringWithFormat:@"%@%@",[XYStringUtil md5String:msgStr],key]];
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:order.u_mobile forKey:@"phoneNum"];
    [parameters setValue:@(2) forKey:@"msgType"];
    [parameters setValue:order.order_id forKey:@"orderCode"];
    [parameters setValue:order.engineer_id forKey:@"engCode"];
    [parameters setValue:order.e_mobile forKey:@"engMobile"];
    [parameters setValue:signStr forKey:@"sign"];
    
    NSString* requestStr = [NSString stringWithFormat:@"https://userapi.hiweixiu.com/sendmsg/send-msg?phoneNum=%@&msgType=2&orderCode=%@&engCode=%@&engMobile=%@&sign=%@",order.u_mobile,order.order_id,order.engineer_id,order.e_mobile,signStr];
    
    [[XYHttpClient sharedInstance]getRequestWithUrl:[requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(id response){
        TTDEBUGLOG(@"%@",[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil]);
    }failure:^(NSString *error) {}];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//+(void)speak:(NSString *)str{
//    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
//    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:str];
//    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
//    utterance.voice = voice;
//    [synthesizer speakUtterance:utterance];
//}
@end
