//
//  XYLeaveViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYLeaveViewController.h"
#import "UIPlaceHolderTextView.h"
#import "XYJustifiedCell.h"
#import "NSDate+DateTools.h"

typedef NS_ENUM(NSInteger, XYLeavePicker){
    XYLeavePickerReason = 1, //是由
    XYLeavePickerTimeStart =  2,    //开始
    XYLeavePickerTimeEnd = 3 , //结束
};

@interface XYLeaveViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTextView;
@property (strong,nonatomic)UIPickerView* reasonPicker;
@property (strong,nonatomic)UIDatePicker* datePicker;

@property (strong,nonatomic) NSArray* titlesArray;
@property (strong,nonatomic) NSArray* reasonsArray;

@property (assign,nonatomic)NSInteger reasonId;
@property (strong,nonatomic)NSString* startTime;
@property (strong,nonatomic)NSString* endTime;
@end

@implementation XYLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self customizeTextView];
}

#pragma mark - override 

- (void)initializeData{
    self.reasonId = 0;
    self.startTime = [[NSDate date] formattedDateWithFormat:@"yyyyMMdd"];
    self.endTime = [[NSDate date] formattedDateWithFormat:@"yyyyMMdd"];
    self.titlesArray = @[@[@"请假类型"],@[@"开始时间",@"结束时间"]];
    self.reasonsArray = [XYAttendanceDto leaveTypeArray];
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"请假申请";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = TABLE_DEVIDER_COLOR;
    [self.tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
    self.tableView.tableFooterView = self.footerView;
    [XYJustifiedCell xy_registerTableView:self.tableView identifier:[XYJustifiedCell defaultReuseId]];
    self.deviderHeight.constant = LINE_HEIGHT;
}

#pragma mark - property

- (void)customizeTextView{
    //备注 这种view放viewDidLoad里会卡。。。
    [self.reasonTextView _initialize];
    self.reasonTextView.placeholder = @"请输入请假事由（必填）";
    self.reasonTextView.maxInputNumber = 150;
    self.reasonTextView.font = [UIFont systemFontOfSize:15];
    self.reasonTextView.backgroundColor = [UIColor whiteColor];
    self.reasonTextView.layer.borderColor = XY_COLOR(204,204,204).CGColor;
    self.reasonTextView.layer.borderWidth = LINE_HEIGHT;
    self.reasonTextView.placeholderTextColor = XY_HEX(0xcccccc);
    self.reasonTextView.textColor = XY_HEX(0x333333);
}

- (UIDatePicker*)datePicker{
    if (!_datePicker){
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChanged:)forControlEvents:UIControlEventValueChanged];
        _datePicker.date = [NSDate date];
    }
    return _datePicker;
}

- (UIPickerView*)reasonPicker{
    if (!_reasonPicker){
        _reasonPicker = [[UIPickerView alloc]init];
        _reasonPicker.delegate = self;
        _reasonPicker.dataSource = self;
    }
    if (self.reasonId >= 0) {
        [_reasonPicker selectRow:self.reasonId inComponent:0 animated:false];
    }
    return _reasonPicker;
}

#pragma mark - selection delegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.datePicker.tag = textField.tag;
    switch (self.datePicker.tag) {
        case XYLeavePickerTimeStart:
            self.datePicker.date = [NSDate dateWithString:self.startTime formatString:@"yyyyMMdd"];
            break;
        case XYLeavePickerTimeEnd:
            self.datePicker.date = [NSDate dateWithString:self.endTime formatString:@"yyyyMMdd"];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case XYLeavePickerReason:
            textField.text = [self.reasonsArray objectAtIndex:self.reasonId];
            break;
        case XYLeavePickerTimeStart:
            textField.text = XY_NOTNULL(self.startTime, @"");
            break;
        case XYLeavePickerTimeEnd:
            textField.text = XY_NOTNULL(self.endTime, @"");
            break;
        default:
            break;
    }
}

- (void)dateChanged:(UIDatePicker*)datePicker{
    if (datePicker.tag == XYLeavePickerTimeStart) {
        self.startTime = [datePicker.date formattedDateWithFormat:@"yyyyMMdd"];
    }else if(datePicker.tag == XYLeavePickerTimeEnd) {
        self.endTime = [datePicker.date formattedDateWithFormat:@"yyyyMMdd"];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.reasonsArray count];
}
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.reasonsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.reasonId = row;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)[self.titlesArray objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYJustifiedCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYJustifiedCell defaultReuseId]];
    cell.titleLabelView.text = [[self.titlesArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.xyTextField.placeholder = @"请选择（必填）";
    cell.xyTextField.delegate = self;
    cell.xyAccessoryMark.hidden = false;
    [self configTextField:cell.xyTextField withPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - textField

- (void)configTextField:(UITextField*)field withPath:(NSIndexPath*)path{
    if (path.section == 0) {
        field.text = [self.reasonsArray objectAtIndex:self.reasonId];
        field.tag = XYLeavePickerReason;
        field.inputView = self.reasonPicker;
    }else if (path.section == 1) {
        switch (path.row) {
            case 0:
                field.text = self.startTime;
                field.tag = XYLeavePickerTimeStart;
                field.inputView = self.datePicker;
                break;
            case 1:
                field.text = self.endTime;
                field.tag = XYLeavePickerTimeEnd;
                field.inputView = self.datePicker;
                break;
            default:
                break;
        }
    }
}

#pragma mark - action

- (IBAction)submit:(id)sender {
    

    if ([self.startTime compare:self.endTime] > 0){
        [self showToast:@"请选择正确日期！"];
        return;
    }
    
    if ([XYStringUtil isNullOrEmpty:self.reasonTextView.text]) {
        [self showToast:@"请填写请假原因！"];
        return;
    }
    
     TTDEBUGLOG(@"sumbit:%@ %@ %@",[self.reasonsArray objectAtIndex:self.reasonId],self.startTime,self.endTime);
    
    [self showLoadingMask];
    __weak typeof(self) weakSelf = self;
    [[XYAPIService shareInstance]submitLeaveRequest:self.reasonId from:self.startTime to:self.endTime reason:self.reasonTextView.text success:^{
        [weakSelf hideLoadingMask];
        [weakSelf showToast:@"提交成功！"];
        if ([weakSelf.delegate respondsToSelector:@selector(onLeaveApplicationSubmitted)]) {
            [weakSelf.delegate onLeaveApplicationSubmitted];
        }
        [weakSelf performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
    } errorString:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
