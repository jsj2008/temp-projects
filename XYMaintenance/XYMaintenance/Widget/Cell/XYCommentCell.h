//
//  XYCommentCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/25.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"
#import "DYRateView.h"

@interface XYCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (weak, nonatomic) IBOutlet DYRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *replyTitleLabel;

+(NSString*)defaultReuseId;
-(void)setData:(XYPHPCommentDto*)data;

@end
