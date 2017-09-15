//
//  XYPICCOrderDetailViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/3.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPICCOrderDetailViewController.h"
#import "XYCustomButton.h"
#import "XYOrderDetailTopCell.h"
#import "XYJustifiedCell.h"
#import "XYCityAreaCell.h"
#import "XYPICCPhotoCell.h"
#import "XYPICCOrderViewModel.h"
#import "XYPICCRemarkViewController.h"
#import "XYSelectCityViewController.h"
#import "XYSelectDeviceTypeViewController.h"
#import "XYSelectPICCAgencyViewController.h"
#import "XYInputCustomDeviceViewController.h"

@interface XYPICCOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XYPICCOrderCallBackDelegate,XYSelectCityDelegate,XYSelectDeviceTypeDelegate,UITextFieldDelegate,XYPICCPhotoCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XYSelectPICCAgencyDelegate,XYCustomDeviceDelegate,XYPICCRemarkDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet XYCustomButton *uploadButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property(strong,nonatomic) XYPICCPhotoCell* photoCell;

@property(strong,nonatomic) XYPICCOrderViewModel* viewModel;
@property(strong,nonatomic) XYSelectDeviceTypeViewController* deviceViewController;

@end

@implementation XYPICCOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.viewModel getPICCOrderByOddNumber:self.odd_number];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.deviceViewController = nil;
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
    self.viewModel = [[XYPICCOrderViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"保险订单详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = TABLE_DEVIDER_COLOR;
    [self.tableView setTableHeaderView:nil];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)]];
    [XYOrderDetailTopCell xy_registerTableView:self.tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
    [XYJustifiedCell xy_registerTableView:self.tableView identifier:[XYJustifiedCell defaultReuseId]];
    [XYCityAreaCell xy_registerTableView:self.tableView identifier:[XYCityAreaCell defaultReuseId]];
    [XYPICCPhotoCell xy_registerTableView:self.tableView identifier:[XYPICCPhotoCell defaultReuseId]];
    [self.uploadButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    //开始隐藏
    self.uploadButton.hidden = true;
    self.deviderHeight.constant = LINE_HEIGHT;
}


#pragma mark - property

- (XYSelectDeviceTypeViewController*)deviceViewController{
    if (!_deviceViewController){
        _deviceViewController = [[XYSelectDeviceTypeViewController alloc]initWithType:XYOrderDeviceTypeInsurance allowCustomize:true delegate:self allowedBrand:nil allowedColor:nil];
    }
    return _deviceViewController;
}

- (XYJustifiedCell*)getJustifiedCellByIndexPath:(NSIndexPath*)path{
    XYJustifiedCell* cell = [[[NSBundle mainBundle]loadNibNamed:[XYJustifiedCell defaultReuseId] owner:self options:nil]lastObject];
    cell.xyTextField.delegate = self;
    cell.xyTextField.tag = path.section*10+path.row;
    XYPICCOrderCellType type = [self.viewModel getCellTypeByPath:path];
    cell.xyTextField.userInteractionEnabled = [self.viewModel getInputableByType:type] ;
    cell.xyTextField.keyboardType = [self.viewModel getKeyboardByType:type];
    cell.xyAccessoryMark.hidden = ![self.viewModel getSelectableByType:type];
    cell.titleLabelView.text = [self.viewModel getTitleByPath:path];
    cell.xyTextField.text = [self.viewModel getInputContentByPath:path];
    cell.xyTextField.placeholder = [self.viewModel getPlaceHolderByType:type];
    [cell.xyTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.orderIdLabel.text = [NSString stringWithFormat:@"保险订单  %@",self.viewModel.orderDetail.odd_number];
    topCell.statusLabel.text = self.viewModel.orderDetail.statusStr;
    return topCell;
}


- (XYPICCPhotoCell*)photoCell{
    if (!_photoCell) {
        _photoCell = [[[NSBundle mainBundle]loadNibNamed:[XYPICCPhotoCell defaultReuseId] owner:self options:nil]lastObject];
        _photoCell.delegate = self;
    }
    _photoCell.equip_pic1 = [NSURL URLWithString:self.viewModel.orderDetail.equip_pic1];
    _photoCell.equip_pic2 = [NSURL URLWithString:self.viewModel.orderDetail.equip_pic2];
    _photoCell.idcard_pic1 = [NSURL URLWithString:self.viewModel.orderDetail.idcard_pic1];
    _photoCell.idcard_pic2 = [NSURL URLWithString:self.viewModel.orderDetail.idcard_pic2];
    _photoCell.canRetakePhoto = [self.viewModel getEditable];
    return _photoCell;
}

- (XYCityAreaCell*)getCityAreaCell{
    XYCityAreaCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYCityAreaCell defaultReuseId]];
    [cell setCity:self.viewModel.orderDetail.city_name area:self.viewModel.orderDetail.district_name];
    return cell;
}

#pragma mark - textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkButtonEnability];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger section = textField.tag/10;
    NSInteger row = textField.tag%10;
    
    XYPICCOrderCellType type = [self.viewModel getCellTypeByPath:[NSIndexPath indexPathForRow:row inSection:section]];
    if (type == XYPICCOrderCellTypePhone) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canType = [string isEqualToString:filtered];
        if (!canType) {
            return canType;//不能输入 直接返回
        }
    }
    //可以输入
    NSString* inputContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.viewModel setInputContent:inputContent type:type];
    return true;
}

- (void)textFieldEditChanged:(UITextField *)textField{
    NSInteger section = textField.tag/10;
    NSInteger row = textField.tag%10;
    XYPICCOrderCellType type = [self.viewModel getCellTypeByPath:[NSIndexPath indexPathForRow:row inSection:section]];
    NSString* inputContent = textField.text;
    [self.viewModel setInputContent:inputContent type:type];
}


- (void)checkButtonEnability{
    [self.uploadButton setButtonEnable:[self.viewModel getUploadable]];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)[self.viewModel.titleArray objectAtIndex:section]count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getTopCell];
    }else if(indexPath.section == [self.viewModel.titleArray count]-1){
        return self.photoCell;
    }else if(indexPath.section == 1 && indexPath.row == 2){
        return [self getCityAreaCell];
    }else{
        return [self getJustifiedCellByIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == 1 && indexPath.row == 2){
        //不可编辑啊 啊啊啊ca
        if (![self.viewModel getEditable]) {
            return;
        }
        [self doSelectCity];
    }else{
        XYPICCOrderCellType type = [self.viewModel getCellTypeByPath:indexPath];
        if (type == XYPICCOrderCellTypeDevice) {
            //不可编辑啊 啊啊啊ca
            if (![self.viewModel getEditable]) {
                return;
            }
            [self doSelectDeviceType];
        }else if(type == XYPICCOrderCellTypeCompany || type == XYPICCOrderCellTypePlan){
            //不可编辑啊 啊啊啊ca
            if (![self.viewModel getEditable]) {
                return;
            }
            [self doSelectPlan];
        }else if(type == XYPICCOrderCellTypeRemark){
            [self goToRemarkView];//不可编辑还可以看。。。
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < 4){
        return 45;
    }else{
        return [XYPICCPhotoCell defaultHeight];
    }
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

#pragma mark - action

- (void)doSelectDeviceType{
    [self.navigationController pushViewController:self.deviceViewController animated:true];
}

- (void)customDeviceType{
    XYInputCustomDeviceViewController* customDeviceController = [[XYInputCustomDeviceViewController alloc]init];
    customDeviceController.delegate = self;
    customDeviceController.preProductName = self.viewModel.orderDetail.product_name;
    customDeviceController.preBrandName = self.viewModel.orderDetail.brand_name;
    customDeviceController.preDeviceName = self.viewModel.orderDetail.mould_name;
    customDeviceController.preDevicePrice = [NSString stringWithFormat:@"%@",@(self.viewModel.orderDetail.equip_price)];
    [self.navigationController pushViewController:customDeviceController animated:true];
}

- (void)doSelectCity{
    XYSelectCityViewController* selectCityViewController = [[XYSelectCityViewController alloc]init];
    selectCityViewController.delegate = self;
    [self.navigationController pushViewController:selectCityViewController animated:true];
}

- (void)doSelectPlan{
    XYSelectPICCAgencyViewController* selectAgencyController = [[XYSelectPICCAgencyViewController alloc]init];
    selectAgencyController.delegate = self;
    [self.navigationController pushViewController:selectAgencyController animated:true];
}

- (void)goToRemarkView{
    XYPICCRemarkViewController* remarkViewController = [[XYPICCRemarkViewController alloc]init];
    remarkViewController.remark = self.viewModel.orderDetail.engineer_remark;
    remarkViewController.editable = [self.viewModel getEditable];
    remarkViewController.delegate = self;
    [self.navigationController pushViewController:remarkViewController animated:true];
}

- (void)getPrices{
    
    if (!self.viewModel.orderDetail.mould_id && self.viewModel.orderDetail.equip_price==0) {
        return;//没设备
    }
    
    if ((!self.viewModel.orderDetail.insurer_id)||(!self.viewModel.orderDetail.coverage_id)) {
        return;//没方案
    }
    
    self.viewModel.orderDetail.price = 0;
    self.viewModel.orderDetail.push_money = 0;
    self.viewModel.orderDetail.rate_id = nil;
    [self.tableView reloadData];
    
    NSString* upload_mould_id = nil;
    
    NSString* upload_mould_price  = nil;
    NSString* upload_product_name  = nil;
    NSString* upload_brand_name  = nil;
    NSString* upload_mould_name  = nil;
    
    if (self.viewModel.orderDetail.mould_id !=nil && [self.viewModel.orderDetail.mould_id integerValue]>0) {//有机型
        upload_mould_id = self.viewModel.orderDetail.mould_id;
    }else{//自定义机型
        upload_mould_id = nil;
        upload_mould_price = [NSString stringWithFormat:@"%@",@(self.viewModel.orderDetail.equip_price)];
        upload_product_name = self.viewModel.orderDetail.product_name;
        upload_brand_name = self.viewModel.orderDetail.brand_name;
        upload_mould_name = self.viewModel.orderDetail.mould_name;
    }
    
    [self showLoadingMask];
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]getPICCPriceByCompany:self.viewModel.orderDetail.insurer_id plan:self.viewModel.orderDetail.coverage_id device:upload_mould_id price:upload_mould_price product:upload_product_name brand:upload_brand_name device:upload_mould_name success:^(XYPICCPrice *priceInfo) {
        [weakSelf hideLoadingMask];
        weakSelf.viewModel.orderDetail.rate_id = priceInfo.id;
        weakSelf.viewModel.orderDetail.price = priceInfo.price;
        weakSelf.viewModel.orderDetail.push_money = priceInfo.push;
        [weakSelf.tableView reloadData];
    } errorString:^(NSString *err) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:err];
    }];
}

- (void)submitOrder{
    TTDEBUGLOG(@"submit %@",[self.viewModel.orderDetail mj_keyValues]);
    [self showLoadingMask];
    [self.viewModel submitPICCOrder];
}


#pragma mark - photo

- (void)takePictureWithName:(NSString *)name{
    
    if(![self.viewModel getPhotoTakingAvailable]){
        [self showToast:@"请打开应用摄像头及相册使用权限"];
        return;
    }
    
    self.photoCell.currentPictureTakenName = name;
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",nil];//,@"手机相册",nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){ //{|| buttonIndex == 1)
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [self showToast:@"设备不支持拍照"];
            return;
        }
        [self presentViewController:picker animated:true completion:nil];
    }else{
        self.photoCell.currentPictureTakenName = nil;//取消拍摄
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //压缩保存图片
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *rotatedOriginalImage = [XYWidgetUtil rotateImage:originalImage];
    NSData* data = [XYWidgetUtil resetSizeOfImageData:rotatedOriginalImage maxSize:100];
    TTDEBUGLOG(@"data:%@",@(data.length/1024.0));
    if ([self.viewModel getPhotoSavingAvailable]) {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){//现拍的，先保存到相册
            UIImage* finalImage = [UIImage imageWithData:data];
            UIImageWriteToSavedPhotosAlbum(finalImage, self, nil, NULL);
        }
    }
    [picker dismissViewControllerAnimated:true completion:nil];
    //上传
    [self uploadImage:data];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)uploadImage:(NSData*)imgData{
    [self showLoadingMask];
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]uploadImage:imgData type:XYPictureTypeInsurance parameters:@{@"user_name":XY_NOTNULL(self.viewModel.orderDetail.user_name, [XYAPPSingleton sharedInstance].currentUser.Name)} success:^(NSString *url){
        [weakSelf.viewModel setUrl:url forName:weakSelf.photoCell.currentPictureTakenName];
        [weakSelf.photoCell setUrl:url forName:weakSelf.photoCell.currentPictureTakenName];
        weakSelf.photoCell.currentPictureTakenName = nil;
        [weakSelf hideLoadingMask];
    } errorString:^(NSString *error) {
        weakSelf.photoCell.currentPictureTakenName = nil;
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

#pragma mark - call back

- (void)adjustLayoutByOrder{
    
    if ([self.viewModel getEditable]) {
        self.uploadButton.hidden = false;
        self.bottomMargin.constant = 60;
    }else{
        self.uploadButton.hidden = true;
        self.bottomMargin.constant = 0;
    }
    
}

- (void)onOrderLoaded:(BOOL)success noteString:(NSString *)errorString{
    
    [self hideLoadingMask];
    
    if (success) {
        [self.tableView reloadData];
        [self adjustLayoutByOrder];
    }else{
        [self showToast:errorString];
    }
    
}

- (void)onOrderSubmitted:(BOOL)success noteString:(NSString *)errorString{
    
    [self hideLoadingMask];
    
    if (success) {
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_OLD_ORDER object:nil];
        [self showToast:@"上传信息成功！"];
        [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
    }else{
        [self showToast:errorString];
    }
}

- (void)onCitySelected:(NSString *)cityId city:(NSString *)cityName area:(NSString *)areaId area:(NSString *)areaName{
    self.viewModel.orderDetail.city = cityId;
    self.viewModel.orderDetail.city_name = cityName;
    self.viewModel.orderDetail.district = areaId;
    self.viewModel.orderDetail.district_name = areaName;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
}

- (void)onDeviceSelected:(XYPHPDeviceDto *)device color:(NSString *)colorId newPlan:(NSString *)planId{
    self.viewModel.orderDetail.brand_id =  device.BrandId;
    self.viewModel.orderDetail.mould_id =  device.Id;
    self.viewModel.orderDetail.mould_name =  device.MouldName;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
    //刷新报价
    [self getPrices];
}

- (void)onCustomDeviceSaved:(NSString *)product brand:(NSString *)brand device:(NSString *)device price:(NSInteger)price{
    self.viewModel.orderDetail.mould_id = nil;
    self.viewModel.orderDetail.product_name = product;
    self.viewModel.orderDetail.brand_name = brand;
    self.viewModel.orderDetail.mould_name = device;
    self.viewModel.orderDetail.equip_price = price;
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:true];
    //刷新报价
    [self getPrices];
}

- (void)onAgencySelected:(NSString*)insurerId agency:(NSString*)insurerName plan:(NSString*)planId plan:(NSString*)name{
    self.viewModel.orderDetail.insurer_id = insurerId;
    self.viewModel.orderDetail.coverage_id = planId;
    self.viewModel.orderDetail.company_name = insurerName;
    self.viewModel.orderDetail.insurance_name = name;
    [self.navigationController popToViewController:self animated:true];
    [self.tableView reloadData];
    //刷新报价
    [self getPrices];
}

- (void)onRemarkSaved:(NSString*)selectionString remark:(NSString*)remark joint:(NSString *)jointString{
   self.viewModel.orderDetail.engineer_remark = jointString;
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:true];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


