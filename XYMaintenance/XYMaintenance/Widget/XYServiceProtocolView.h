//
//  XYServiceProtocolView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYServiceProtocolView : UIView

@property (nonatomic,strong) NSURL* linkUrl;
@property (nonatomic,strong) NSString* notice;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* submitTitle;
@property (nonatomic,copy) void(^buttonsDidClick)();

+ (XYServiceProtocolView*)protocolViewWithUrl:(NSURL*)link;

+ (XYServiceProtocolView*)protocolViewWithNotice:(NSString*)notice;

- (void)show;

- (void)dismiss;

@end
