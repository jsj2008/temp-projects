//
//  XYFaultTagsCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/10/9.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYFaultTagsCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@implementation XYFaultTagsCell

- (NSMutableArray*)tagsArray{
    if (!_tagsArray) {
        _tagsArray = [[NSMutableArray alloc]init];
    }
    return _tagsArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagsView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tagsView.interitemSpacing = 15;
    self.tagsView.lineSpacing = 8;
    self.tagsView.preferredMaxLayoutWidth = SCREEN_WIDTH - 145;
    __weak SKTagView *weakView = self.tagsView;
    __weak __typeof__(self) weakSelf = self;
    self.tagsView.didTapTagAtIndex = ^(NSUInteger index){
        NSUInteger planId = [weakView findTagIdAtIndex:index];
        NSString* faultName = [weakView findTextAtIndex:index];
        if ([weakSelf.delegate respondsToSelector:@selector(removeFault:faultName:)]) {
            [weakSelf.delegate removeFault:[NSString stringWithFormat:@"%@",@(planId)] faultName:faultName];
        }
        
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlanIds:(NSString*)rp_id names:(NSString*)faultNames{//planid,name joined by ','{
    
    [self.tagsView removeAllTags];
    
    NSArray* planIdsArray = [rp_id componentsSeparatedByString:@","];
    NSArray* faultNamesArray = [faultNames componentsSeparatedByString:@","];
    for (NSInteger i = 0; i < MIN([planIdsArray count], [faultNamesArray count]); i++) {
        NSUInteger planId = [planIdsArray[i] integerValue];
        NSString* faultName = faultNamesArray[i];
        if (planId == 0 || [XYStringUtil isNullOrEmpty:faultName]) {
            continue;//如果故障id或名字不存在
        }
        SKTag *tag = [SKTag tagWithText:faultName];
        tag.tagId = planId;
        tag.textColor = BLACK_COLOR;
        tag.fontSize = 13;
        tag.enable = true;
        tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
        tag.bgColor = XY_HEX(0xeef0f3);
        tag.cornerRadius = 11;
        [self.tagsView addTag:tag];
    }
}

- (IBAction)addFault:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addFault)]) {
        [self.delegate addFault];
    }
}

+ (NSString*)defaultReuseId{
    return @"XYFaultTagsCell";
}
@end
