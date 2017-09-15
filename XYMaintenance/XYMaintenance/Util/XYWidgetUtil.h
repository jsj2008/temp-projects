//
//  TableViewUtil.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XYWidgetUtil : NSObject

+(UITableView*)getSimpleTableView:(CGRect)frame;

+(UIView*)getSingleLine;

+(UIView*)getClearLine;

+(UIView*)getSingleLineWithColor:(UIColor*)color;

+(UIView*)getSingleLineWithInset:(NSInteger)inset;

+(UITableViewHeaderFooterView*)getSectionHeader:(NSString*)title height:(CGFloat)height headerId:(NSString*)identifier;

+(UIView*)getSimpleSectionHeaderView;

//纯色图
+(UIImage *)imageWithColor:(UIColor *)color;

+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;
+ (UIImage*)rotateImage:(UIImage *)image;
@end
