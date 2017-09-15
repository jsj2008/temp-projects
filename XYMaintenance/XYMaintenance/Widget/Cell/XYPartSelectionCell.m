//
//  XYPartSelectionCell.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/4.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartSelectionCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"
#import "PPNumberButton.h"

@interface XYPartSelectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *partNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNameLabel;
@property (weak, nonatomic) IBOutlet UIView *partNumView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderWidth;
@property (weak, nonatomic) IBOutlet UIView *xybackgroundView;
@property (weak, nonatomic) PPNumberButton *numButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *partCountTitleLabel;

@property (assign, nonatomic) NSInteger num;
@end

@implementation XYPartSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xybackgroundView.layer.borderColor = XY_HEX(0xaeb8c4).CGColor;
    self.xybackgroundView.layer.borderWidth = LINE_HEIGHT;
    self.xybackgroundView.layer.cornerRadius = 2*LINE_HEIGHT;
    self.deviderWidth.constant = self.deviderHeight1.constant = self.deviderHeight2.constant = LINE_HEIGHT;
    [self initNumButton];
}

- (void)initNumButton {
    PPNumberButton *numButton = [PPNumberButton numberButtonWithFrame:CGRectMake(10, 0, 75, 20)];
    numButton.backgroundColor = [UIColor clearColor];
    numButton.shakeAnimation = NO;
    numButton.inputFieldFont = 13;
    numButton.currentNumber = 1;
    numButton.minValue = 1;
    numButton.maxValue = 99;
    numButton.inputFieldFont = 13;
    numButton.increaseImage = [UIImage imageNamed:@"jia"];
    numButton.decreaseImage = [UIImage imageNamed:@"jian"];
    
    numButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"-123-%ld",(long)num);
        self.num = num;
        !_numChangeBlock ?: _numChangeBlock(num);
    };
    self.numButton = numButton;
    [self.partNumView addSubview:self.numButton];
}

+ (CGFloat)defaultHeight{
    return 135;
}

+ (NSString*)defaultReuseId{
    return @"XYPartSelectionCell";
}

- (void)setData:(XYPartsSelectionDto*)data{
    
    if (!data) {
        return;
    }
    
    self.partNoLabel.text = XY_NOTNULL(data.serial_number, @"");
    self.partNameLabel.text = XY_NOTNULL(data.part_name, @"");
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", data.count * [data.master_avg_price floatValue]];
    self.numButton.currentNumber = data.count;
    
    if (data.isHideCellCountView) {
        self.totalPriceLabel.hidden = YES;
        self.partNumView.hidden = YES;
        self.partCountTitleLabel.hidden = YES;
    }else {
        self.totalPriceLabel.hidden = NO;
        self.partNumView.hidden = NO;
        self.partCountTitleLabel.hidden = NO;
    }
    
}
@end
