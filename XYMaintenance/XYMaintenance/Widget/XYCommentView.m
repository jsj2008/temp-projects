//
//  XYCommentView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYCommentView.h"
#import "XYConfig.h"
#import "DYRateView.h"

@interface XYCommentView ()

@property (weak, nonatomic) IBOutlet UILabel *commentTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;


@property(strong,nonatomic)DYRateView* rateView;

@end


@implementation XYCommentView

+(XYCommentView*)getCommentView{
  return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

-(void)setData:(XYPHPCommentDto*)data
{
    if (!data) {
        return;
    }

    self.commentTimeLable.text = data.commentTime;
    self.commentContentLabel.text = data.comment.Content;
    self.replyTimeLabel.text = data.replyTime;
    self.replyContentLabel.text = data.reply.ReplyContent;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
