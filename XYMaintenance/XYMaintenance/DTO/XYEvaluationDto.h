//
//  XYEvaluationDto.h
//  XYMaintenance
//
//  Created by lisd on 2017/5/2.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYEvaluationDto : NSObject
@property(copy,nonatomic)NSString* favorable_rate;
@property(copy,nonatomic)NSString* accept_order_count;
@property(copy,nonatomic)NSString* afterSale_order_count;
@property(copy,nonatomic)NSString* eng_counts;
@property(copy,nonatomic)NSString* user_comment_count;
@property(copy,nonatomic)NSString* five_star;
@property(copy,nonatomic)NSString* four_star;
@property(copy,nonatomic)NSString* three_star;
@property(copy,nonatomic)NSString* two_star;
@property(copy,nonatomic)NSString* one_star;

@property(assign,nonatomic)NSInteger row;
@end
