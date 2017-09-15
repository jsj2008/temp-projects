//
//  XYCommentCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/25.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYCommentCell.h"

@implementation XYCommentCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString*)defaultReuseId{
   return @"XYCommentCell";
}

-(void)setData:(XYPHPCommentDto*)data
{
    if (!data) {
        return;
    }
    
    self.rateView.rate = data.comment.grade;
    self.rateView.userInteractionEnabled=false;
    self.commentTimeLabel.text = data.commentTime;
    self.commentLabel.text = data.comment.Content;
    
    if ((!data.reply.CreateTime) ||data.reply.CreateTime.length==0) {
        self.replyTimeLabel.text = @"";
        self.replyLabel.text = @"";
        self.replyTitleLabel.text = @"";
    }else{
        self.replyTimeLabel.text = data.replyTime;
        self.replyLabel.text = data.reply.ReplyContent;
        self.replyTitleLabel.text = @"Hi回复";
    }
}


@end
