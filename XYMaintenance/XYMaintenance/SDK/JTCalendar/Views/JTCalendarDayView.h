//
//  JTCalendarDayView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>
#import "JTCalendarDay.h"

@interface JTCalendarDayView : UIView<JTCalendarDay>

@property (nonatomic, weak) JTCalendarManager *manager;
@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) UIView *circleView;
@property (nonatomic, readonly) UIView *dotView;
@property (nonatomic, readonly) UIView *topLine;
@property (nonatomic, readonly) UILabel *textLabel;

@property (nonatomic) CGFloat circleRatio;
@property (nonatomic) CGFloat dotRatio;

@property (nonatomic) BOOL isFromAnotherMonth;

/*!
 * Must be call if override the class
 */
- (void)commonInit;


//@property (nonatomic, readonly) UILabel *subTextLabel;

@end
