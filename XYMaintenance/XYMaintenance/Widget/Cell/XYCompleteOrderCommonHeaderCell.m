//
//  XYCompleteOrderCommonHeaderCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/11.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYCompleteOrderCommonHeaderCell.h"

@interface XYCompleteOrderCommonHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopMargin;

@end

@implementation XYCompleteOrderCommonHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.indicatorImgView.hidden = YES;
}

+ (NSString*)defaultReuseId{
    return @"XYCompleteOrderCommonHeaderCell";
}

-(void)setIsFirst:(BOOL)isFirst {
    if (isFirst) {
        self.topViewHeight.constant = 0;
        self.viewTopMargin.constant = 0;
    }else {
        self.topViewHeight.constant = 10;
        self.viewTopMargin.constant = 10;
    }
}
@end
