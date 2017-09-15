//
//  XYCompleteOrderSpecialHeaderCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/11.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYCompleteOrderSpecialHeaderCell.h"

@interface XYCompleteOrderSpecialHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgView;

@end

@implementation XYCompleteOrderSpecialHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString*)defaultReuseId{
    return @"XYCompleteOrderSpecialHeaderCell";
}

- (IBAction)selectAll:(id)sender {
    !_selectAllBlock ?: _selectAllBlock();
}

-(void)setIsSelectAll:(BOOL)isSelectAll {
    if (isSelectAll) {
        self.selectedImgView.image = [UIImage imageNamed:@"gouxuan_cur"];
    }else {
        self.selectedImgView.image = [UIImage imageNamed:@"gouxuan"];
    }
}
@end
