 //
//  XYRecycleInputInfoViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleInputInfoViewController.h"
#import "XYJustifiedCell.h"
#import "XYCityAreaCell.h"
#import "XYOrderDetailTopCell.h"
#import "XYRecycleUserInfoViewModel.h"
#import "XYRecyleSignViewController.h"
#import "XYSelectCityViewController.h"

@interface XYRecycleInputInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XYSelectCityDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)XYRecycleUserInfoViewModel* viewModel;
@property (strong,nonatomic)UIPickerView* payPicker;
@end

@implementation XYRecycleInputInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeModelBinding{
    
    self.viewModel = [[XYRecycleUserInfoViewModel alloc]init];
    
    //初始化原订单信息
    self.viewModel.orderDetail = self.preOrderDetail;
}

- (void)initializeUIElements{
   
    self.navigationItem.title = @"用户信息";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = TABLE_DEVIDER_COLOR;
    [self.tableView setTableHeaderView:nil];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)]];
    [XYCityAreaCell xy_registerTableView:self.tableView identifier:[XYCityAreaCell defaultReuseId]];
    [XYJustifiedCell xy_registerTableView:self.tableView identifier:[XYJustifiedCell defaultReuseId]];
    [XYOrderDetailTopCell xy_registerTableView:self.tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
}

#pragma mark - property

- (UIPickerView*)payPicker{
    if (!_payPicker){
        _payPicker = [[UIPickerView alloc]init];
        _payPicker.delegate = self;
        _payPicker.dataSource = self;
    }
    [_payPicker selectRow:self.viewModel.orderDetail.payment_method inComponent:0 animated:false];
    return _payPicker;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)[self.viewModel.titleArray objectAtIndex:section]count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYRecycleUserCellType cellType = [self.viewModel getCellTypeByPath:indexPath];
    if (cellType == XYRecycleUserCellTypeTitle) {
        return [self getTopCell];
    }else if(cellType == XYRecycleUserCellTypeCityArea){
        return [self getCityAreaCell];
    }else{
        return [self getJustifiedCellByIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYRecycleUserCellType cellType = [self.viewModel getCellTypeByPath:indexPath];
    if (cellType == XYRecycleUserCellTypeCityArea) {
        [self doSelectCity];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LINE_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - cell

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.orderIdLabel.text = XY_NOTNULL(self.viewModel.orderDetail.mould_name, @"回收设备");
    topCell.statusLabel.text = [NSString stringWithFormat:@"回收估价：￥%@",@(self.estimatePrice)];
    return topCell;
}

- (XYCityAreaCell*)getCityAreaCell{
    XYCityAreaCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYCityAreaCell defaultReuseId]];
    [cell setCity:self.viewModel.orderDetail.city_name area:self.viewModel.orderDetail.district_name];
    return cell;
}

- (XYJustifiedCell*)getJustifiedCellByIndexPath:(NSIndexPath*)path{
    XYJustifiedCell* cell = [[[NSBundle mainBundle]loadNibNamed:[XYJustifiedCell defaultReuseId] owner:self options:nil]lastObject];
    cell.xyTextField.delegate = self;
    cell.xyTextField.tag = path.section*10+path.row;
    XYRecycleUserCellType type = [self.viewModel getCellTypeByPath:path];
    cell.xyTextField.userInteractionEnabled = [self.viewModel getInputableByType:type] ;
    cell.xyAccessoryMark.hidden = ![self.viewModel getSelectableByType:type];
    cell.titleLabelView.text = [self.viewModel getTitleByPath:path];
    cell.xyTextField.text = [self.viewModel getInputContentByPath:path];
    cell.xyTextField.placeholder = [self.viewModel getPlaceHolderByType:type];
    [cell.xyTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.xyTextField.delegate = self;
    if (type == XYRecycleUserCellTypePayType) {
        cell.xyTextField.inputView = self.payPicker;
    }else{
        cell.xyTextField.keyboardType = [self.viewModel getKeyboardByType:type];
    }
    return cell;
}

#pragma mark - delegate

- (void)textFieldEditChanged:(UITextField *)textField{
    NSInteger section = textField.tag/10;
    NSInteger row = textField.tag%10;
    XYRecycleUserCellType type = [self.viewModel getCellTypeByPath:[NSIndexPath indexPathForRow:row inSection:section]];
    NSString* inputContent = textField.text;
    [self.viewModel setInputContent:inputContent type:type];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger section = textField.tag/10;
    NSInteger row = textField.tag%10;
    XYRecycleUserCellType type = [self.viewModel getCellTypeByPath:[NSIndexPath indexPathForRow:row inSection:section]];
    if ([self.viewModel getKeyboardByType:type] == UIKeyboardTypeNumberPad) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (type == XYRecycleUserCellTypeIdentity) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSX_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return true;
}

- (IBAction)nextStep:(id)sender {
     
    //判断填满
    if (![self.viewModel isUserInfoAllFilled]) {
        [self showToast:@"请填写完整信息"];
        return;
    }

    XYRecyleSignViewController* signViewController = [[XYRecyleSignViewController alloc]init];
    signViewController.viewModel = self.viewModel;
    [self.navigationController pushViewController:signViewController animated:true];
}

- (void)doSelectCity{
    XYSelectCityViewController* selectCityViewController = [[XYSelectCityViewController alloc]init];
    selectCityViewController.delegate = self;
    [self.navigationController pushViewController:selectCityViewController animated:true];
}


#pragma mark - delegate

- (void)onCitySelected:(NSString *)cityId city:(NSString *)cityName area:(NSString *)areaId area:(NSString *)areaName{
    self.viewModel.orderDetail.city = cityId;
    self.viewModel.orderDetail.city_name = cityName;
    self.viewModel.orderDetail.district = areaId;
    self.viewModel.orderDetail.district_name = areaName;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
}

#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.viewModel.orderDetail.payTypeArray count];
}
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.viewModel.orderDetail.payTypeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.viewModel.orderDetail.payment_method = row;
    [self.viewModel setInputContent:self.viewModel.orderDetail.payTypeStr type:XYRecycleUserCellTypePayType];
    [self.tableView reloadData];
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
