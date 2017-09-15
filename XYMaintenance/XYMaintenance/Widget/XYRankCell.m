//
//  XYRankCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRankCell.h"
#import "XYConfig.h"
#import "UIImageView+YYWebImage.h"
#import "XYWidgetUtil.h"
#import "XYAPPSingleton.h"
#import "XYStringUtil.h"

@interface XYRankCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *workerIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
//城市的头像
@property (weak, nonatomic) IBOutlet UIView *cityIconView;
@property (weak, nonatomic) IBOutlet UILabel *cityIconLabel;

@end

@implementation XYRankCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatarImageView.layer.cornerRadius = 25;
    self.avatarImageView.layer.masksToBounds = true;
    self.cityIconView.layer.cornerRadius = 25;
    self.cityIconView.layer.masksToBounds = true;
    self.cityIconView.layer.borderWidth = 2.0f;
    self.cityIconView.layer.borderColor = THEME_COLOR.CGColor;
    self.cityIconLabel.textColor = THEME_COLOR;
    self.cityIconLabel.font = SMALL_TEXT_FONT;
    self.rankImageView.hidden = true;
    self.rankLabel.hidden = false;
    self.rankLabel.textColor = self.moneyLabel.textColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYRankCell";
}

+ (CGFloat)defaultHeight{
    return 70;
}

- (void)setRankData:(XYRankDto*)data{
    if (data) {
        [self setRank:data.key];
        if (![XYStringUtil isNullOrEmpty:data.image_url]) {
            [self setImageUrl:data.image_url];
        }
        
        self.workerIdLabel.text = [NSString stringWithFormat:@"工号 %@",data.engineer_name];
        self.moneyLabel.text = [[XYAPPSingleton sharedInstance] shouldBlockBonusInRankList]?@"":[NSString stringWithFormat:@"￥%@  ",@(data.push_money)];
        self.orderLabel.text = [NSString stringWithFormat:@"%@单",@(data.order_num)];
        self.cityLabel.text = XY_NOTNULL(data.city_name, @"");
    }
    self.cityIconView.hidden = self.cityIconLabel.hidden = true;
}

- (void)setPromotionData:(XYPromotionRankDto*)data type:(XYRankingListType)type{
    if (data) {
        [self setRank:data.key];
        switch (type) {
            case XYRankingListTypePromotionCity:
            {
                UIImage* cityImage;
                if (![XYStringUtil isNullOrEmpty:data.city]) {
                    cityImage = [UIImage imageNamed:[XYPromotionRankDto getPictureNameByCity:data.city]];
                }
                if (cityImage) {
                    //如果存在城市图标
                    self.cityIconView.hidden = self.cityIconLabel.hidden = true;
                    self.avatarImageView.image = cityImage;
                }else{//否则显示文字即可
                    self.cityIconView.hidden = self.cityIconLabel.hidden = false;
                    self.cityIconLabel.text = XY_NOTNULL(data.name, @"");
                }
                self.workerIdLabel.text = [NSString stringWithFormat:@"人均推广：%@单",data.avg_counts];
                self.moneyLabel.text = @"";
                self.orderLabel.text = [NSString stringWithFormat:@"总推广：%@单",@(data.total_promotion_counts)];
                self.cityLabel.text = @"";
            }
                break;
            case XYRankingListTypePromotionPerson:
            {
                self.cityIconView.hidden = self.cityIconLabel.hidden = true;
                if (![XYStringUtil isNullOrEmpty:data.Url]) {
                    [self setImageUrl:data.Url];
                }
                self.workerIdLabel.text = [NSString stringWithFormat:@"工号：%@",data.name];
                self.moneyLabel.text = @"";
                self.orderLabel.text = [NSString stringWithFormat:@"本月推广：%@单",@(data.month_counts)];
                self.cityLabel.text = XY_NOTNULL(data.region_name, @"");
            }
                break;
            default:
                break;
        }
    }
}

- (void)setRank:(NSInteger)rank{
    if (rank >=1 && rank <=3) {
        self.rankLabel.hidden = true;
        self.rankImageView.hidden = false;
        self.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank%@",@(rank)]];
    }else{
        self.rankLabel.hidden = false;
        self.rankImageView.hidden = true;
        self.rankLabel.text = [NSString stringWithFormat:@"%@",@(rank)];
    }
}

- (void)setImageUrl:(NSString*)imageUrl{

    NSString* imgUrl = [XYStringUtil urlTohttps:imageUrl];
    
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"img_avatar"] options:YYWebImageOptionHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        TTDEBUGLOG(@"%@ before compress: %@ K",imgUrl,@(UIImageJPEGRepresentation(image,1.0).length/1024.0));
        //压缩图片
        NSData* compressData = [XYWidgetUtil resetSizeOfImageData:image maxSize:10];
        TTDEBUGLOG(@"compress data: %@ K",@(compressData.length/1024.0));
        return [UIImage imageWithData:compressData];
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    
}

@end
