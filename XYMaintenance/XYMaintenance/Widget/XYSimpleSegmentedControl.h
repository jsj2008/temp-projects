//
//  XYSimpleSegmentedControl.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/10.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSimpleSegmentedControl : UIControl

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, copy) void (^indexChangeBlock)(NSUInteger index);
@property (nonatomic, strong) UIColor *backgroundColor; // default is [UIColor whiteColor]
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, readwrite) CGFloat height;
@property (nonatomic, strong) CALayer *underLineLayer;// default is 32.0

- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;

@end
