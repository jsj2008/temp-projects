//
//  BaseViewModel.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAPIService.h"
#import "API.h"
#import "XYConfig.h"
#import "XYAPPSingleton.h"
#import "DTO.h"
#import "XYDtoTransferer.h"
#import "XYStrings.h"


/**
 *  ViewModel通常是与页面一一对应 管理该页面的所有数据来源和请求 以相应的事件delegate回调
 */
@interface XYBaseViewModel : NSObject
/**
 *  添加请求
 *
 *  @param requestId 请求编号
 */
-(void)registerRequestId:(NSNumber*)requestId;

/**
 *  请求完成后移除编号
 *
 *  @param requestId 请求编号
 */
-(void)removeRequestId:(NSNumber*)requestId;

/**
 *  取消所有请求(页面关闭时)
 */
-(void)cancelAllRequests;

@end
