//
//  XYPartSelectionsViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYPartDto.h"
@protocol XYPartSelectionsDelegate <NSObject>
- (void)onPartsSelected:(XYPartsSelectionDto *)partsSelection;
@end

@interface XYPartSelectionsViewController : XYBaseViewController
@property (nonatomic,copy) void (^onPartsSelectedBlock)(XYPartsSelectionDto *partSelection);
@property(strong,nonatomic) NSArray* partsArray;

- (instancetype)initWithDevice:(NSString*)deviceId
                         fault:(NSString*)faultId
                         color:(NSString*)colorId
                      delegate:(id<XYPartSelectionsDelegate>)delegate;

@end
