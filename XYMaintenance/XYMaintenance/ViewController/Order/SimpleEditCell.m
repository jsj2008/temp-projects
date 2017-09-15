//
//  SimpleEditCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "SimpleEditCell.h"
#import "XYStringUtil.h"
#import "XYConfig.h"
#import "NSDate+DateTools.h"
#import "XYDtoTransferer.h"
#import "UIView+Frame.h"
#import "HttpCache.h"

typedef NS_ENUM(NSInteger, XYPeriodDateViewSection) {
    XYPeriodDateViewSectionDate = 0,//日期
    XYPeriodDateViewSectionTime = 1,//时间段
};
static const NSInteger SERIALNUM_LENGTH = 15;
#warning 这是什么
#define ALPHANUM_ONLY @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface SimpleEditCell ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    XYSimpleEditCellType _type;
}

@property(strong,nonatomic) UIPickerView* datePickerView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end


@implementation SimpleEditCell

- (void)awakeFromNib {
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"SimpleEditCell";
}

- (void)setEditType:(XYSimpleEditCellType)type{
    [self.inputField endEditing:false];
    self.inputField.userInteractionEnabled = false;
    self.inputField.delegate = self;
    _type = type;
}

- (void)startEditing{
    
    if (self.inputField.userInteractionEnabled) {
        return;
    }
    
    self.inputField.userInteractionEnabled = true;
    self.inputField.textColor = BLUE_COLOR;
    
    if (_type == XYSimpleEditCellTypeOrderedTime){
        self.inputField.inputView = self.datePickerView;
        [self.inputField becomeFirstResponder];
        [self pickerViewLoadData];
    }
    else if (_type == XYSimpleEditCellTypeSerialNumber){
        self.inputField.inputView = nil;
        self.inputField.keyboardType = UIKeyboardTypeDefault;
        [self.inputField becomeFirstResponder];
    }else if(_type == XYSimpleEditCellTypeRemark){
        self.inputField.inputView = nil;
        self.inputField.keyboardType = UIKeyboardTypeDefault;
        [self.inputField becomeFirstResponder];
    }else if(_type == XYSimpleEditCellTypePartMoney){
        self.inputField.textColor = THEME_COLOR;
        self.inputField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.inputField becomeFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if(_type == XYSimpleEditCellTypeSerialNumber){
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]) && (newLength <= SERIALNUM_LENGTH));
    }
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.inputField resignFirstResponder];
    self.inputField.userInteractionEnabled = false;
    self.inputField.textColor = BLACK_COLOR;
    
    if (_type == XYSimpleEditCellTypeOrderedTime)
    {
        if (![XYStringUtil isNullOrEmpty:self.inputField.text]) {
            [self.editCellDelegate onTimeEdited:self.selectDate timePeriod:self.selectPeriod];
        }
       
        _datePickerView = nil;
        _dateArr = nil;
        self.selectDate = nil;
        self.selectPeriod = nil;
    }
    else if (_type == XYSimpleEditCellTypeSerialNumber)
    {
        if (![XYStringUtil isNullOrEmpty:self.inputField.text])
        {
            [self.editCellDelegate onEditingEnded:self.inputField.text type:_type];
        }
    }
    else if(_type == XYSimpleEditCellTypeRemark)
    {
        if (![XYStringUtil isNullOrEmpty:self.inputField.text])
        {
            [self.editCellDelegate onEditingEnded:self.inputField.text type:_type];
        }
    }
}

- (UIPickerView*)datePickerView{
    
    if (!_datePickerView){
        _datePickerView = [[UIPickerView alloc] init];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
    }
    
    return _datePickerView;
}

- (void)pickerViewLoadData {
    NSArray *arr = (NSArray*)[[HttpCache sharedInstance] objectForKey:cache_reservetimeList];
    self.dateArr = arr;
//    self.selectDate = self.dateArr[0];
//    self.selectPeriod = self.selectDate.periods[0];
    
    
    [self.datePickerView reloadAllComponents];
    [self pickerView:self.datePickerView didSelectRow:0 inComponent:0];
}

-(NSArray<XYReservetimeDateDto *> *)dateArr {
    if (!_dateArr) {
        _dateArr = [NSArray array];
    }
    return _dateArr;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == XYPeriodDateViewSectionDate) {
        return self.dateArr.count;
    }else  {
        if (self.dateArr.count < 1) {
            return 0;
        }else{
            NSInteger dateIndex = [pickerView selectedRowInComponent:0];
            
            XYReservetimeDateDto *model = self.dateArr[dateIndex];
            return model.periods.count;
        }
        
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (!self.dateArr.count) {
        return nil;
    }
    if(component == XYPeriodDateViewSectionDate){
        XYReservetimeDateDto *model = self.dateArr[row];
        return model.dateStr;
    }
    if(component == XYPeriodDateViewSectionTime){
        NSInteger dateIndex = [pickerView selectedRowInComponent:0];
        XYReservetimeDateDto *model = self.dateArr[dateIndex];
        if (!model.periods.count) {
            return nil;
        }
        if (row<model.periods.count) {
            XYReservetimePeriodDto *period = model.periods[row];
            return [NSString stringWithFormat:@"%@~%@", period.start_time, period.next_time];
        }
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == XYPeriodDateViewSectionDate){
        [self.datePickerView reloadComponent:1];
        [self.datePickerView selectRow:0 inComponent:1 animated:YES];
        if (row>=self.dateArr.count) {
            return;
        }
        XYReservetimeDateDto *model = self.dateArr[row];
        self.selectDate = model;
        self.selectPeriod = [model.periods firstObject];
    }else if(component == XYPeriodDateViewSectionTime){
        NSInteger dateIndex = [pickerView selectedRowInComponent:0];
        XYReservetimeDateDto *model = self.dateArr[dateIndex];
        self.selectDate = model;
        if (row>=model.periods.count) {
            return;
        }
        self.selectPeriod = model.periods[row];
    }
    self.inputField.text = [XYDtoTransferer xy_reservetimeTransform:self.selectPeriod.start_timestamp reserveTime2:self.selectPeriod.next_timestamp];
}


@end
