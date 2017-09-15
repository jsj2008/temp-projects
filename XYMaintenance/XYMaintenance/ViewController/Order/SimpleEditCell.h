//
//  SimpleEditCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDtoContainer.h"
#import "XYReservetimeDto.h"

typedef NS_ENUM(NSInteger, XYSimpleEditCellType){
    XYSimpleEditCellTypeInvalid = -1,
    XYSimpleEditCellTypeOrderedTime = 0, //修改预约时间
    XYSimpleEditCellTypeSerialNumber = 1, //修改序列号
    XYSimpleEditCellTypeRemark = 2,   //备注
    XYSimpleEditCellTypePartMoney = 3,
};

@protocol SimpleEditCellDelegate <NSObject>

- (void)onEditingEnded:(NSString*)str type:(XYSimpleEditCellType)type;

- (void)onTimeEdited:(XYReservetimeDateDto*)date timePeriod:(XYReservetimePeriodDto *)timePeriod;

@end


@interface SimpleEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *xyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (assign, nonatomic, readonly) XYSimpleEditCellType xyCellType;
@property (assign, nonatomic)id<SimpleEditCellDelegate> editCellDelegate;

@property (nonatomic,strong) NSArray <XYReservetimeDateDto *>*dateArr;
@property (nonatomic, strong) XYReservetimePeriodDto *selectPeriod;
@property (nonatomic, strong) XYReservetimeDateDto *selectDate;
+ (NSString*)defaultReuseId;
- (void)setEditType:(XYSimpleEditCellType)type;
- (void)startEditing;


@end
