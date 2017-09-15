//
//  HMSegmentedControl.h
//  HMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYImageSegmentedControl : UIControl

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, copy) void (^indexChangeBlock)(NSUInteger index);
@property (nonatomic, strong) UIColor *backgroundColor; // default is [UIColor whiteColor]
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat height; // default is 32.0


- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;

@end
