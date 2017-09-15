//
//  XYWarningTitleView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYWarningTitleView.h"
#import "XYConfig.h"

@interface XYWarningTitleView ()
@property(strong,nonatomic) UILabel* warningLabel;
@end

@implementation XYWarningTitleView

- (instancetype)init{
    if (self = [super init]){
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    self.backgroundColor = YELLOW_COLOR;
    [self addSubview:self.warningLabel];
}

- (UILabel*)warningLabel{
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 25)];
        _warningLabel.textAlignment = NSTextAlignmentLeft;
        _warningLabel.backgroundColor = YELLOW_COLOR;
        _warningLabel.font = SIMPLE_TEXT_FONT;
        _warningLabel.textColor = THEME_COLOR;
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}

- (void)setWarningText:(NSString*)str{
    
    self.warningLabel.text = str;
    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 100) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.warningLabel.font} context:nil].size;
    self.warningLabel.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, (NSInteger)size.height);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, (NSInteger)size.height + 20);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
