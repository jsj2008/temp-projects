//
//  XYOrderDetailFooterView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/25.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYOrderDetailFooterView.h"
#import "XYConfig.h"
#import "TableViewUtil.h"

@implementation XYOrderDetailFooterView

+(instancetype)getFooterView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

-(void)setComment:(BOOL)isComment content:(XYPHPCommentDto*)comment{
    if (!isComment) {
        self.commentView.hidden=true;
    }else{
        self.commentView.hidden=false;
        [self.commentView setData:comment];
    }
}

-(void)resetButtons{
    for (id subView in self.buttonsView.subviews) {
            [subView removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
