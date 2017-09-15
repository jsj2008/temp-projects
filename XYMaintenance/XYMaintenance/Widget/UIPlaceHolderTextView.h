//
//  UIPlaceHolderTextView.h
//  Matrix
//
//  Created by Justin on 12-9-18.
//  Copyright (c) 2012年 apple.inc. All rights reserved.
//

// Note: code from SSToolKit

#import <UIKit/UIKit.h>


@protocol UIPlaceHolderTextViewCountDelegate <NSObject>
- (void)refreshLeftCountLabel:(NSInteger)leftCount;
@end

@interface UIPlaceHolderTextView : UITextView<UITextViewDelegate>
@property(nonatomic, assign) id<UIPlaceHolderTextViewCountDelegate> countDelegate;
@property(nonatomic, assign) NSInteger maxInputNumber;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) UIColor *placeholderTextColor;

- (void)_initialize;
- (void)onTextDidChanged;

@end
