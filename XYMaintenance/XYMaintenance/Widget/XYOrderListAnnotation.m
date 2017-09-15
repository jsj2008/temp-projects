//
//  XYOrderListAnnotation.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYOrderListAnnotation.h"
#import "XYConfig.h"


@implementation XYOrderMapAnnotation
@end

@implementation XYOrderListAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.bounds = CGRectMake(0.f, 0.f, 64, 67);
        self.backgroundColor = [UIColor clearColor];
        /* 背景色 */
        self.imgLayer = [[UIImageView alloc]init];
        self.imgLayer.frame = CGRectMake(0, 0, 64, 39);
        self.imgLayer.image = [UIImage imageNamed:@"order_anno_white"];
        [self addSubview:self.imgLayer];
        /* Create annotation */
        self.annoLayer = [[UIImageView alloc]init];
        self.annoLayer.frame = CGRectMake(21.5, 40, 21, 27);
        [self addSubview:self.annoLayer];
        /* Create time label. */
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 64, 15)];
        self.timeLabel.backgroundColor  = [UIColor clearColor];
//        self.timeLabel.numberOfLines = 0;
        self.timeLabel.textAlignment    = NSTextAlignmentCenter;
        self.timeLabel.textColor        =  THEME_COLOR;
        self.timeLabel.font             =  [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.timeLabel];
        //清空原有订单信息
        //[self.ordersArray removeAllObjects];
    }
    
    return self;
}

#pragma mark - property

- (void)setOrderLevel:(NSInteger)orderLevel{
    _orderLevel = orderLevel;
    self.annoLayer.hidden = (orderLevel > 0);
    self.bounds = CGRectMake(0, 0, 64, self.annoLayer.hidden?39:67);
    self.centerOffset = CGPointMake(0, (-30)*orderLevel - (self.annoLayer.hidden?14:0));
}

- (void)setType:(XYOrderListAnnotationType)type{
    _type = type;
    switch (type) {
        case XYOrderListAnnotationTypeTheme:
            self.annoLayer.image = [UIImage imageNamed:@"order_map_point_theme"];
            break;
        case XYOrderListAnnotationTypeBlue:
            self.annoLayer.image = [UIImage imageNamed:@"order_map_point_reverse"];
            break;
        default:
            break;
    }
    self.isXYSelected = false;
}

- (void)setIsXYSelected:(BOOL)isXYSelected{
    _isXYSelected = isXYSelected;
    if (isXYSelected) {
        self.timeLabel.textColor     =  WHITE_COLOR;
        switch (self.type) {
            case XYOrderListAnnotationTypeTheme:
                self.imgLayer.image = [UIImage imageNamed:@"order_anno_theme"];
                break;
            case XYOrderListAnnotationTypeBlue:
                self.imgLayer.image = [UIImage imageNamed:@"order_anno_reverse"];
                break;
            default:
                break;
        }
    }else{
        switch (self.type) {
            case XYOrderListAnnotationTypeTheme:
                self.timeLabel.textColor = THEME_COLOR;
                break;
            case XYOrderListAnnotationTypeBlue:
                self.timeLabel.textColor = REVERSE_COLOR;
                break;
            default:
                break;
        }
        self.imgLayer.image = [UIImage imageNamed:@"order_anno_white"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
