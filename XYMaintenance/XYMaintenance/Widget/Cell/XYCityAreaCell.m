//
//  XYCityAreaCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYCityAreaCell.h"
#import "XYConfig.h"

@implementation XYCityAreaCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    self.titleLabelView.lineHeightScale = 0.65;
//    self.titleLabelView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineTop;
//    self.titleLabelView.fdTextAlignment = FDTextAlignmentFill;
//    self.titleLabelView.fdAutoFitMode = FDAutoFitModeContrainedFrame;
//    self.titleLabelView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    self.titleLabelView.text = @"客户地址";
    self.titleLabelView.textColor = LIGHT_TEXT_COLOR;
    
    self.cityField.userInteractionEnabled = false;
    self.areaField.userInteractionEnabled = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)defaultHeight{
    return 45;
}

+(NSString*)defaultReuseId{
   return @"XYCityAreaCell";
}

- (void)setCity:(NSString *)city area:(NSString *)area{
    if ([city hasSuffix:@"市"]) {
        self.cityField.text =  [city substringToIndex:[city length]-1];
    }else{
        self.cityField.text =  city;
    }
    if ([area hasSuffix:@"区"]) {
        self.areaField.text =  [area substringToIndex:[area length]-1];
    }else{
        self.areaField.text =  area;
    }
}
@end
