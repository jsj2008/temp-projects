//
//  LocationUtil.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/15.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  坐标监控更新和上报，，需求未定
 */
@interface XYLocationUtil : NSObject

+(XYLocationUtil*)sharedInstance;

-(void)startLocating;
-(void)stopLocating;

@end
