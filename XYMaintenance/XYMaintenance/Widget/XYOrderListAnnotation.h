//
//  XYOrderListAnnotation.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//


#import <MAMapKit/MAMapKit.h>
#import "XYDtoContainer.h"

typedef NS_ENUM(NSInteger, XYOrderListAnnotationType) {
    XYOrderListAnnotationTypeUnknown = 0,
    XYOrderListAnnotationTypeTheme = 1,
    XYOrderListAnnotationTypeBlue = 2,
};

@interface XYOrderMapAnnotation : MAPointAnnotation

@property (strong, nonatomic) NSString* orderId;
@property (assign, nonatomic) XYBrandType bid;
@property (strong, nonatomic) NSString* timeString;
@property (assign, nonatomic) NSInteger orderLevel;

@end


@interface XYOrderListAnnotationView : MAAnnotationView

@property (assign, nonatomic) XYOrderListAnnotationType type;//标注点选中底图
@property (assign, nonatomic) BOOL isXYSelected;//是否选中
@property (assign, nonatomic) NSInteger orderLevel; //层级 防止订单标注点重合 默认都为0 重合点level升高


@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UIImageView* imgLayer;
@property (strong, nonatomic) UIImageView* annoLayer;

@end
