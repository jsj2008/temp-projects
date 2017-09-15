   //
//  XYAddOrderViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYAddOrderViewController.h"
#import "XYSelectDeviceTypeViewController.h"
#import "XYSelectPlanViewController.h"
#import "XYSelectCityViewController.h"
#import "XYAddOrderViewModel.h"
#import "XYWarningTitleView.h"
#import "XYJustifiedCell.h"
#import "XYCityAreaCell.h"
#import "XYCustomButton.h"
#import "XYSMSRequestCell.h"

@interface XYAddOrderViewController ()<UITableViewDataSource,UITableViewDelegate,XYAddOrderCallBackDelegate,XYSelectDeviceTypeDelegate,XYSelectRepairingPlanDelegate,XYSelectCityDelegate,UITextFieldDelegate>

@property(strong,nonatomic)XYWarningTitleView* titleView;
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)XYCustomButton* submitButton;
@property(strong,nonatomic)XYSMSRequestCell* codeCell;

@property(strong,nonatomic)XYAddOrderViewModel* viewModel;
@property(strong,nonatomic)XYSelectDeviceTypeViewController* deviceViewController;

@end

@implementation XYAddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.deviceViewController = nil;
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:false];
}

- (void)dealloc{
    self.viewModel.delegate = nil;
    [self.viewModel cancelAllRequests];
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYAddOrderViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"添加订单";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.titleView];
    [self resetWarningText];
    [self.view addSubview:self.tableView];
}

#pragma mark - property

- (XYWarningTitleView*)titleView{
    if (!_titleView) {
        _titleView = [[XYWarningTitleView alloc]init];
    }
    return _titleView;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.titleView.frame.size.height + 10, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - self.navigationController.navigationBar.frame.size.height - (self.titleView.frame.size.height + 10))];
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:[self getTableFooterView]];
        [XYCityAreaCell xy_registerTableView:_tableView identifier:[XYCityAreaCell defaultReuseId]];
        [XYJustifiedCell xy_registerTableView:_tableView identifier:[XYJustifiedCell defaultReuseId]];
        [XYSMSRequestCell xy_registerTableView:_tableView identifier:[XYSMSRequestCell defaultReuseId]];
    }
    return _tableView;
}

- (XYCustomButton*)submitButton{
    if (!_submitButton) {
        _submitButton = [[XYCustomButton alloc]initWithFrame:CGRectMake(15,  25, SCREEN_WIDTH - 30, 40)];
        [_submitButton setTitle:@"预约订单" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setButtonEnable:false];
    }
    return _submitButton;
}

- (XYSMSRequestCell*)codeCell{
    if (!_codeCell) {
        _codeCell = [[[NSBundle mainBundle]loadNibNamed:[XYSMSRequestCell defaultReuseId] owner:self options:nil]lastObject];
    }
    [_codeCell.sendCodeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    _codeCell.xyTextField.delegate = self;
    _codeCell.xyTextField.tag = XYAddOrderCellTypeVerifyCode;
    _codeCell.xyTextField.text = XY_NOTNULL(self.viewModel.code, @"");
    return _codeCell;
}

- (UIView*)getTableFooterView{
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [footerView addSubview:[XYWidgetUtil getSingleLineWithInset:15]];
    [footerView addSubview:self.submitButton];
    return footerView;
}

- (XYSelectDeviceTypeViewController*)deviceViewController{
    if (!_deviceViewController){
        _deviceViewController = [[XYSelectDeviceTypeViewController alloc]initWithType:XYOrderDeviceTypeRepair allowCustomize:false delegate:self allowedBrand:nil allowedColor:nil];
    }
    return _deviceViewController;
}

#pragma mark - action

- (void)sendCode:(UIButton*)sender{
    if ([XYStringUtil isNullOrEmpty:self.viewModel.phone] || self.viewModel.phone.length!=11){
        [self showToast:@"请输入手机号"];
        return;
    }
    [self.codeCell.sendCodeButton startCountDown];
    [self.viewModel getVerifyCode:self.viewModel.phone];
}

- (void)doSelectDeviceType{
    [self.navigationController pushViewController:self.deviceViewController animated:true];
}

- (void)doSelectFault{
    if (self.viewModel.device == nil || [XYStringUtil isNullOrEmpty:self.viewModel.device.MouldName]){
        [self showWarningText:TT_NO_DEVICE_TYPE];
        return;
    }
    XYSelectPlanViewController* selectPlanViewController = [[XYSelectPlanViewController alloc]initWithDevice:self.viewModel.device.Id brand:self.viewModel.device.BrandId bid:self.viewModel.device.bid allowedColor:nil editOrderType:XYOrderTypeNormal];
    selectPlanViewController.delegate = self;
    [self.navigationController pushViewController:selectPlanViewController animated:true];
}

- (void)doSelectCity{
    XYSelectCityViewController* selectCityViewController = [[XYSelectCityViewController alloc]init];
    selectCityViewController.delegate = self;
    [self.navigationController pushViewController:selectCityViewController animated:true];
}

- (void)submitOrder{
    [self.view endEditing:false];
    [self showLoadingMask];
    [self.viewModel doSubmitOrderWithPhone:self.viewModel.phone andName:self.viewModel.name address:self.viewModel.address];
}

#pragma mark - warning

- (void)showWarningText:(NSString*)str{
    [self.titleView setWarningText:[NSString stringWithFormat:@"提示：%@",str]];
}

- (void)resetWarningText{
    [self.titleView setWarningText:@"提示：订单信息请写完整后提交"];
}

- (void)checkButtonEnability{
    BOOL btnShouldDisable = (self.viewModel.device == nil) ||[XYStringUtil isNullOrEmpty:self.viewModel.device.MouldName]||[XYStringUtil isNullOrEmpty:self.viewModel.color]||[XYStringUtil isNullOrEmpty:self.viewModel.plan]||[XYStringUtil isNullOrEmpty:self.viewModel.name]||[XYStringUtil isNullOrEmpty:self.viewModel.phone]||[XYStringUtil isNullOrEmpty:self.viewModel.code]||[XYStringUtil isNullOrEmpty:self.viewModel.cityId]||[XYStringUtil isNullOrEmpty:self.viewModel.address]||[XYStringUtil isNullOrEmpty:self.viewModel.areaId];
    [self.submitButton setButtonEnable:!btnShouldDisable];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYAddOrderCellType type = [self.viewModel getCellTypeByPath:indexPath];
    if (type == XYAddOrderCellTypeCityArea) {
        XYCityAreaCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYCityAreaCell defaultReuseId]];
        [cell setCity:self.viewModel.cityName area:self.viewModel.areaName];
        return cell;
    }else if(type == XYAddOrderCellTypeVerifyCode){
        return self.codeCell;
    }else{
        XYJustifiedCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYJustifiedCell defaultReuseId]];
        cell.xyTextField.tag = type;
        cell.xyTextField.delegate = self;
        [cell.xyTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.titleLabelView.text = [self.viewModel getTitleByPath:indexPath];
        cell.xyTextField.text = XY_NOTNULL([self.viewModel getInputContentByPath:indexPath], @"");
        cell.xyTextField.userInteractionEnabled = [self.viewModel getInputableByType:type];
        cell.xyAccessoryMark.hidden = ![self.viewModel getSelectableByType:type];
        cell.xyTextField.placeholder = XY_NOTNULL([self.viewModel getPlaceHolderByType:type], @"");
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYAddOrderCellType type = [self.viewModel getCellTypeByPath:indexPath];
    switch (type) {
        case XYAddOrderCellTypeDevice:
            [self doSelectDeviceType];
            break;
        case XYAddOrderCellTypeFault:
            [self doSelectFault];
            break;
        case XYAddOrderCellTypeCityArea:
            [self doSelectCity];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkButtonEnability];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger section = textField.tag/10;
    NSInteger row = textField.tag%10;
    XYAddOrderCellType type = [self.viewModel getCellTypeByPath:[NSIndexPath indexPathForRow:row inSection:section]];
    switch (type) {
        case XYAddOrderCellTypePhone:
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL canType = [string isEqualToString:filtered];
            if (canType) {
                self.viewModel.phone = [textField.text stringByReplacingCharactersInRange:range withString:string];
            }
            return canType;
        }
            break;
        case XYAddOrderCellTypeName:
        {
            self.viewModel.name = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
            break;
        case XYAddOrderCellTypeAddress:
        {
            self.viewModel.address = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
            break;
        case XYAddOrderCellTypeVerifyCode:
            self.viewModel.code = [textField.text stringByReplacingCharactersInRange:range withString:string];
            break;
        default:
            break;
    }
    return true;
}

- (void)textFieldEditChanged:(UITextField *)textField{
    NSInteger section = textField.tag/10;
    NSInteger row = textField.tag%10;
    XYAddOrderCellType type = [self.viewModel getCellTypeByPath:[NSIndexPath indexPathForRow:row inSection:section]];
    NSString* inputContent = textField.text;
    if (type == XYAddOrderCellTypePhone) {
        self.viewModel.phone = inputContent;
    }else if(type == XYAddOrderCellTypeName){
        self.viewModel.name = inputContent;
    }else if(type == XYAddOrderCellTypeAddress){
        self.viewModel.address = inputContent;
    }
}

#pragma mark - view delegate

- (void)onDeviceSelected:(XYPHPDeviceDto *)device color:(NSString *)colorId newPlan:(NSString *)planId{
    self.viewModel.device = device;
    self.viewModel.color = colorId;
    self.viewModel.colorName = nil;
    self.viewModel.plan = planId;
    self.viewModel.planDescription = nil;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
    [self resetWarningText];
}

- (void)onRepairingPlanSelected:(NSString *)planId color:(NSString *)colorName colorId:(NSString *)colorId repairType:(NSString *)planDescription{
    self.viewModel.plan = planId;
    self.viewModel.color = colorId;
    self.viewModel.colorName = colorName;
    self.viewModel.planDescription = planDescription;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
    [self resetWarningText];
    [self checkButtonEnability];
}

- (void)onCitySelected:(NSString*)cityId city:(NSString *)cityName area:(NSString *)areaId area:(NSString *)areaName{
    self.viewModel.cityId = cityId;
    self.viewModel.cityName = cityName;
    self.viewModel.areaId = areaId;
    self.viewModel.areaName = areaName;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
    [self resetWarningText];
    [self checkButtonEnability];
}

- (void)onOrderSubmitted:(BOOL)success noteString:(NSString *)errorString{
    [self hideLoadingMask];
    if (success){
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
        [self showToast:TT_ORDER_SUCCESS];
        [self performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
    }else{
        [self showToast:errorString];
    }
}

- (void)onVerifyCodeSent:(BOOL)success note:(NSString *)note{
    if (success) {
        [self showToast:@"验证码发送成功，请查看手机短信！"];
    }else{
        [self.codeCell.sendCodeButton reset];
        [self showToast:note];
    }
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
