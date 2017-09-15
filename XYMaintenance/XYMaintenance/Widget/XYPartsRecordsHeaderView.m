//
//  XYPartsRecordsHeaderView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/11/21.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPartsRecordsHeaderView.h"
#import "XYConfig.h"
#import "NSDate+DateTools.h"
#import "XYStringUtil.h"
#import "SDTrackTool.h"

@interface XYPartsRecordsHeaderView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight3;
@property (weak, nonatomic) IBOutlet UIView *partView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partViewHeight;
@property (weak, nonatomic) IBOutlet UIView *resultHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultHeaderHeight;
//日期选择器
@property(strong,nonatomic) UIDatePicker* datePicker;
@end

@implementation XYPartsRecordsHeaderView

+ (XYPartsRecordsHeaderView*)recordsHeaderView{
    XYPartsRecordsHeaderView* recordsHeaderView = [[XYPartsRecordsHeaderView alloc]init];
    recordsHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 235);
    recordsHeaderView.tag = 0;
    recordsHeaderView.startTimeField.tag = XYPartsFlowTimeTypeStart;
    recordsHeaderView.endTimeField.tag = XYPartsFlowTimeTypeEnd;
    return recordsHeaderView;
}

+ (XYPartsRecordsHeaderView*)filtertimeView{
    XYPartsRecordsHeaderView* filtertimeView = [[XYPartsRecordsHeaderView alloc]init];
    filtertimeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130.5);
    filtertimeView.partView.hidden = YES;
    filtertimeView.partViewHeight.constant = 0;
    filtertimeView.resultHeaderView.hidden = YES;
    filtertimeView.resultHeaderHeight.constant = 0;
    filtertimeView.tag = 1;
    filtertimeView.startTimeField.tag = XYPartsFlowTimeTypeStart_partApplyLog;
    filtertimeView.endTimeField.tag = XYPartsFlowTimeTypeEnd_partApplyLog;
    return filtertimeView;
}

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYPartsRecordsHeaderView" owner:self options:nil] objectAtIndex:0];
    self.backgroundColor = [UIColor whiteColor];
    self.searchButton.backgroundColor = THEME_COLOR;
    self.deviderHeight1.constant = self.deviderHeight2.constant = self.deviderHeight3.constant = LINE_HEIGHT;
    self.startTimeField.delegate = self.endTimeField.delegate = self;
    
    return self;
}

- (IBAction)doSearch:(id)sender {
    [[sender superview] class];
    UIView *senderSuperView = [sender superview];
    if (!senderSuperView) {
        return;
    }
    switch (senderSuperView.tag) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(doSearchPartsFlow)]) {
                [self.delegate doSearchPartsFlow];
            }
            [SDTrackTool logEvent:@"CTRL_EVENT_XYPartsRecordsHeaderView_SEARCHFLOW"];
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(doSearchPartsApplyLog)]) {
                [self.delegate doSearchPartsApplyLog];
            }
            [SDTrackTool logEvent:@"CTRL_EVENT_XYPartsRecordsHeaderView_SEARCHAPPLY"];
            break;
        default:
            break;
    }
    
}

- (IBAction)selectStartTime:(id)sender {
    [self.endTimeField resignFirstResponder];
    if ([XYStringUtil isNullOrEmpty:self.startTimeField.text]) {
        self.datePicker.date = [NSDate date];
    }else{
        self.datePicker.date = [NSDate dateWithString:self.startTimeField.text formatString:@"yyyy-MM-dd"];
    }
    self.startTimeField.inputView = self.datePicker;
    [self.startTimeField becomeFirstResponder];
    self.startTimeField.text = [self.datePicker.date formattedDateWithFormat:@"yyyy-MM-dd"];
    
    UIView *senderSuperView = [sender superview];
    if (!senderSuperView) {
        return;
    }
    switch (senderSuperView.tag) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectDate:type:)]) {
                [self.delegate selectDate:self.startTimeField.text type:XYPartsFlowTimeTypeStart];
            }
            self.datePicker.tag = XYPartsFlowTimeTypeStart;
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectDate:type:)]) {
                [self.delegate selectDate:self.startTimeField.text type:XYPartsFlowTimeTypeStart_partApplyLog];
            }
            self.datePicker.tag = XYPartsFlowTimeTypeStart_partApplyLog;
            break;
        default:
            break;
    }
}

- (IBAction)selectEndTime:(id)sender {
    [self.startTimeField resignFirstResponder];
    if ([XYStringUtil isNullOrEmpty:self.endTimeField.text]) {
        self.datePicker.date = [NSDate date];
    }else{
        self.datePicker.date = [NSDate dateWithString:self.endTimeField.text formatString:@"yyyy-MM-dd"];
    }
    self.endTimeField.inputView = self.datePicker;
    [self.endTimeField becomeFirstResponder];
    self.endTimeField.text = [self.datePicker.date formattedDateWithFormat:@"yyyy-MM-dd"];
    
    [[sender superview] class];
    UIView *senderSuperView = [sender superview];
    if (!senderSuperView) {
        return;
    }
    switch (senderSuperView.tag) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectDate:type:)]) {
                [self.delegate selectDate:self.endTimeField.text type:XYPartsFlowTimeTypeEnd];
            }
            self.datePicker.tag = XYPartsFlowTimeTypeEnd;
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectDate:type:)]) {
                [self.delegate selectDate:self.startTimeField.text type:XYPartsFlowTimeTypeEnd_partApplyLog];
            }
            self.datePicker.tag = XYPartsFlowTimeTypeEnd_partApplyLog;
            break;
        default:
            break;
    }

//    [self.delegate selectDate:self.endTimeField.text type:XYPartsFlowTimeTypeEnd];
}

- (IBAction)selectParts:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectPart)]) {
        [self.delegate selectPart];
    }
}

- (UIDatePicker*)datePicker{
    if (!_datePicker){
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}


- (void)dateChange:(UIDatePicker*)picker{
    switch (picker.tag) {
        case XYPartsFlowTimeTypeStart:
            self.startTimeField.text = [picker.date formattedDateWithFormat:@"yyyy-MM-dd"];
            break;
        case XYPartsFlowTimeTypeEnd:
            self.endTimeField.text = [picker.date formattedDateWithFormat:@"yyyy-MM-dd"];
            break;
        case XYPartsFlowTimeTypeStart_partApplyLog:
            self.startTimeField.text = [picker.date formattedDateWithFormat:@"yyyy-MM-dd"];
            break;
        case XYPartsFlowTimeTypeEnd_partApplyLog:
            self.endTimeField.text = [picker.date formattedDateWithFormat:@"yyyy-MM-dd"];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(selectDate:type:)]) {
        [self.delegate selectDate:textField.text type:textField.tag];
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
