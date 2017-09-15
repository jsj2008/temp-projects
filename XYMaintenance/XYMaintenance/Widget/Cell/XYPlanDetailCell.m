//
//  XYPlanDetailCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYPlanDetailCell.h"
#import "XYConfig.h"

@interface XYPlanDetailCell ()

@property(strong,nonatomic) UIView* gridBackgroundView;
@property(strong,nonatomic) UILabel* detailLabel;
@property(strong,nonatomic) UILabel* planTitleLabel;
@property(strong,nonatomic) UILabel* planLabel;
@property(strong,nonatomic) UILabel* priceTitleLabel;
@property(strong,nonatomic) UILabel* priceLabel;
@property(strong,nonatomic) UIView* verticalDevider;
@property(strong,nonatomic) UIView* adjustableDevider;

@end

@implementation XYPlanDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString*)defaultReuseId{
   return @"XYPlanDetailCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI{
    
    CGFloat defaultHeight = 135;
    
    self.gridBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, defaultHeight)];
    self.gridBackgroundView.backgroundColor = GRIDVIEW_COLOR;
    self.gridBackgroundView.layer.cornerRadius = 2.0f;
    self.gridBackgroundView.layer.borderWidth = LINE_HEIGHT;
    self.gridBackgroundView.layer.borderColor = GRIDVIEW_BORDRE_COLOR.CGColor;
    self.gridBackgroundView.layer.masksToBounds = true;
    [self.contentView addSubview:self.gridBackgroundView];
    
    UILabel* detailTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 77, defaultHeight/3)];
    detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    detailTitleLabel.textColor = LIGHT_TEXT_COLOR;
    detailTitleLabel.text = @"故障详情";
    detailTitleLabel.font = SIMPLE_TEXT_FONT;
    detailTitleLabel.backgroundColor = GRIDVIEW_COLOR;
    [self.gridBackgroundView addSubview:detailTitleLabel];
    
    self.planTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.gridBackgroundView.bounds.size.height/3, 77, defaultHeight/3)];
    self.planTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.planTitleLabel.textColor = LIGHT_TEXT_COLOR;
    self.planTitleLabel.text = @"维修方案";
    self.planTitleLabel.font = SIMPLE_TEXT_FONT;
    self.planTitleLabel.backgroundColor = GRIDVIEW_COLOR;
    [self.gridBackgroundView addSubview:self.planTitleLabel];
    
    self.priceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.gridBackgroundView.bounds.size.height*2.0/3, 77, defaultHeight/3)];
    self.priceTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.priceTitleLabel.textColor = LIGHT_TEXT_COLOR;
    self.priceTitleLabel.text = @"维修价格";
    self.priceTitleLabel.font = SIMPLE_TEXT_FONT;
    self.priceTitleLabel.backgroundColor = GRIDVIEW_COLOR;
    [self.gridBackgroundView addSubview:self.priceTitleLabel];

    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, self.gridBackgroundView.bounds.size.width - 78 - 15, 15)];
    self.detailLabel.center = CGPointMake(self.detailLabel.center.x, detailTitleLabel.center.y);
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textColor = BLACK_COLOR;
    self.detailLabel.font = LARGE_TEXT_FONT;
    self.detailLabel.backgroundColor = GRIDVIEW_COLOR;
    [self.gridBackgroundView addSubview:self.detailLabel];
    
    self.planLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, self.gridBackgroundView.bounds.size.width - 78 - 15, 15)];
    self.planLabel.center = CGPointMake(self.planLabel.center.x, self.planTitleLabel.center.y);
    self.planLabel.textAlignment = NSTextAlignmentLeft;
    self.planLabel.numberOfLines = 0;
    self.planLabel.textColor = BLACK_COLOR;
    self.planLabel.font = LARGE_TEXT_FONT;
    self.planLabel.backgroundColor = GRIDVIEW_COLOR;
    [self.gridBackgroundView addSubview:self.planLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, self.gridBackgroundView.bounds.size.width - 78 - 15, 15)];
    self.priceLabel.center = CGPointMake(self.priceLabel.center.x, self.priceTitleLabel.center.y);
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.textColor = THEME_COLOR;
    self.priceLabel.font = LARGE_TEXT_FONT;
    self.priceLabel.backgroundColor = GRIDVIEW_COLOR;
    [self.gridBackgroundView addSubview:self.priceLabel];
    
    self.verticalDevider = [[UIView alloc]initWithFrame:CGRectMake(77, 0, LINE_HEIGHT, self.gridBackgroundView.bounds.size.height)];
    self.verticalDevider.backgroundColor = GRIDVIEW_DIVIDER_COLOR;
    [self.gridBackgroundView addSubview:self.verticalDevider];
    
    UIView* horizontalDevider = [[UIView alloc]initWithFrame:CGRectMake(0, self.gridBackgroundView.bounds.size.height/3, self.gridBackgroundView.bounds.size.width,LINE_HEIGHT)];
    horizontalDevider.backgroundColor = GRIDVIEW_DIVIDER_COLOR;
    [self.gridBackgroundView addSubview:horizontalDevider];
    
    self.adjustableDevider = [[UIView alloc]initWithFrame:CGRectMake(0, self.gridBackgroundView.bounds.size.height*2.0/3, self.gridBackgroundView.bounds.size.width,LINE_HEIGHT)];
    self.adjustableDevider.backgroundColor = GRIDVIEW_DIVIDER_COLOR;
    [self.gridBackgroundView addSubview:self.adjustableDevider];
}


- (void)setData:(XYPlanDto*)data{
    
    if (!data) {
        return;
    }
    
    self.detailLabel.text = data.fault_name;
    self.planLabel.text = data.RepairType;
    self.priceLabel.text = data.Price;
    
    if (data.cellHeight < 10)
    {
        data.cellHeight = [XYPlanDetailCell getCellHeightOfRepairType:data.RepairType];
    }
    
    TTDEBUGLOG(@"height = %lf,data = %@",data.cellHeight,data.fault_name);
    
    self.planLabel.frame = CGRectMake(88, 55, self.gridBackgroundView.bounds.size.width - 88 - 15, data.cellHeight);
    self.planTitleLabel.center = CGPointMake(self.planTitleLabel.center.x, self.planLabel.center.y);
    self.adjustableDevider.frame = CGRectMake(0, self.planLabel.frame.size.height + self.planLabel.frame.origin.y + 10, self.gridBackgroundView.bounds.size.width,LINE_HEIGHT);
    self.priceTitleLabel.frame = CGRectMake(0, self.adjustableDevider.frame.size.height + self.adjustableDevider.frame.origin.y, 77, self.priceTitleLabel.frame.size.height);
    self.priceLabel.center = CGPointMake(self.priceLabel.center.x, self.priceTitleLabel.center.y);
    self.verticalDevider.frame = CGRectMake(77, 0, LINE_HEIGHT, self.priceTitleLabel.frame.size.height + self.priceTitleLabel.frame.origin.y);
    self.gridBackgroundView.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, self.verticalDevider.frame.size.height);
    
    TTDEBUGLOG(@"whole height = %lf ,data = %@",self.gridBackgroundView.frame.size.height + 15,data.fault_name);
}

+(CGFloat)getCellHeightOfRepairType:(NSString*)str
{
    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - 88 - 15, 1000) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: LARGE_TEXT_FONT} context:nil].size;
    
    return size.height;
}

@end
