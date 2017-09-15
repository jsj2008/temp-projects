//
//  XYWaterMarkLabel.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYWaterMarkLabel : UILabel

+ (XYWaterMarkLabel*)createWaterMarkLabel;

- (void)updateWithAngle:(NSInteger)angle marks:(NSInteger)numberOfMarks content:(NSString*)content;

- (void)clearWaterMark;

@end
