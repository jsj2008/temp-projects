//
//  DYMonthlyCalendarView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/13.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYMonthlyCalendarViewDelegate <NSObject>
@required
- (void)selectMonthOfYear:(NSInteger)year month:(NSInteger)month;//字面意义的年月
@end


@interface DYMonthlyCalendarView : UIView

@property (nonatomic, weak) id<DYMonthlyCalendarViewDelegate> monthDelegate;
@property (assign,nonatomic)NSInteger chosenYear;
@property (assign,nonatomic)NSInteger chosenMonth;

-(void)setDefaultYear:(NSInteger)year andMonth:(NSInteger)month;

@end
