//
//  XYWaterMarkLabel.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYWaterMarkLabel.h"
#import "XYConfig.h"

@implementation XYWaterMarkLabel

+ (XYWaterMarkLabel*)createWaterMarkLabel{
    
        XYWaterMarkLabel* waterMarkLabel = [[XYWaterMarkLabel alloc]init];
        waterMarkLabel.userInteractionEnabled = false;
        waterMarkLabel.font = [UIFont systemFontOfSize:15];
        waterMarkLabel.textColor = [UIColor colorWithWhite:0 alpha:0.10];
        waterMarkLabel.numberOfLines = 0;
        waterMarkLabel.textAlignment = NSTextAlignmentCenter;
        return waterMarkLabel;
}

- (void)updateWithAngle:(NSInteger)angle marks:(NSInteger)numberOfMarks content:(NSString*)content{
    
    if (!content) {
        [self clearWaterMark];
        return;
    }
    //计算宽高
    CGFloat newWidth = (SCREEN_HEIGHT+tan(angle*M_PI / 180.0)*SCREEN_WIDTH)/sqrt((tan(angle*M_PI / 180.0)*tan(angle*M_PI / 180.0)+1));
    CGFloat newHeight = (SCREEN_HEIGHT+tan(angle*M_PI / 180.0)*SCREEN_WIDTH)/sqrt((tan(angle*M_PI / 180.0)*tan(angle*M_PI / 180.0)+1));
    TTDEBUGLOG(@"newWidth %@ newHeight %@",@(newWidth),@(newHeight));
    self.frame = CGRectMake((SCREEN_WIDTH-newWidth)/2, (SCREEN_HEIGHT-newHeight)/2, newWidth, newHeight);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:self.frame.size.height/(numberOfMarks-1)-30];
    TTDEBUGLOG(@"setMinimumLineHeight:%@ %@",@(self.frame.size.height),@(self.frame.size.height/(numberOfMarks-1)));
    //生成文本
    NSMutableString* str = [[NSMutableString alloc]init];
    for(NSInteger i = 0; i < numberOfMarks*2; i ++){
        [str appendString:content];
        NSInteger numberOfInsetSpacings = 20 + arc4random()%80;//缩进
        TTDEBUGLOG(@"numberOfInsetSpacings:%@",@(numberOfInsetSpacings));
        for(NSInteger j = 1; j < numberOfInsetSpacings; j ++){
            [str appendString:@" "];
        }
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.attributedText = attributedString;
    self.transform = CGAffineTransformMakeRotation((360-angle)*M_PI / 180.0);
}

- (void)clearWaterMark{
    [self updateWithAngle:0 marks:0 content:@""];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
