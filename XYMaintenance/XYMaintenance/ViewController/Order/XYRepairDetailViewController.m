//
//  XYRepairDetailViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRepairDetailViewController.h"
#import "XYRepairDetailCell.h"
#import "XYCustomButton.h"
#import "UIControl+XYButtonClickDelayer.h"
#import "UIAlertView+Blocks.h"
#import "UIImageView+YYWebImage.h"
#import "XYPhotoBigImageView.h"
#import "XYLocationManagerWithTimer.h"
#import "XYServiceProtocolView.h"

@interface XYRepairDetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,XYPhotoBigImageViewDelegate>

@property (strong,nonatomic) NSArray* titleArray;
@property (strong,nonatomic) NSArray* paramArray;
@property (strong,nonatomic) NSMutableDictionary* resultMap;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet XYCustomButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerDeviderHeight;

@property (assign,nonatomic) XYPictureType currentPictureTaken;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property (weak, nonatomic) IBOutlet UILabel *wechatTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation XYRepairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 要求自拍
    [self takePhoto:XYPictureTypeSelfPhotoTaking];
    //update footer
    self.tableView.hidden = false;
    self.detailLabel.text = [NSString stringWithFormat:@"维修方案：%@%@\n维修金额：%@元\n消耗配件：%@",self.device,self.plan,@(self.totalPrice),self.parts];
    self.detailLabel.textColor = THEME_COLOR;
    //魅族订单不要微信推广
    self.alertLabel.hidden = self.wechatTitleLabel.hidden = self.photoImageView.hidden = self.photoImageButton.hidden = [self.viewModel isMeizuOrder];
}

#pragma mark - override

- (void)initializeData{
    
    self.titleArray = [XYRepairSelections repairSelectionTitlesArray];
    self.paramArray = [XYRepairSelections repairSelectionParamsArray];
    
    self.resultMap = [[NSMutableDictionary alloc]init];
    for(NSString* str in self.paramArray){
        [self.resultMap setValue:@(-1) forKey:str];
    }
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"维修信息确认";
    self.deviderHeight.constant = self.footerDeviderHeight.constant = LINE_HEIGHT;
    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:self.footerView];
    [XYRepairDetailCell xy_registerTableView:self.tableView identifier:[XYRepairDetailCell defaultReuseId]];
    [self.photoImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.orderDetail.weixin_promotion_img] placeholder:[UIImage imageNamed:@"photo_add"]];
    //防止重复点击
    self.submitButton.uxy_acceptEventInterval = 2.0;
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel isMeizuOrder]?0:[self.titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYRepairDetailCell defaultHeight];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYRepairDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYRepairDetailCell defaultReuseId]];
    cell.contentLabel.text = [NSString stringWithFormat:@" %@",[self.titleArray objectAtIndex:indexPath.row]];
    cell.segmentControl.tag = indexPath.row;
    [cell.segmentControl addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventValueChanged];
    
    NSString* param = [self.paramArray objectAtIndex:indexPath.row];
    NSNumber* selectedNumber = [self.resultMap objectForKey:param];
    if (selectedNumber) {
        cell.segmentControl.selectedSegmentIndex = [selectedNumber integerValue];
    }else{
        cell.segmentControl.selectedSegmentIndex = -1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


#pragma mark - action

- (void)segSelected:(UISegmentedControl*)control{
    NSString* param = [self.paramArray objectAtIndex:control.tag];
    [self.resultMap setValue: @(control.selectedSegmentIndex) forKey:param];
}

- (void)getSelectionItems{
    //todo
}

- (IBAction)submitOrder:(id)sender{
    
    if (![self.viewModel allPhotosTaken]) {//前页照片必须都已拍摄
        [self showToast:@"请拍摄维修设备相关照片！"];
        return;
    }
    
    if (![self.viewModel isMeizuOrder]) {//魅族不需要这些选项
        //判断项目
        for(NSString* str in self.paramArray){
            NSNumber* number = [self.resultMap valueForKey:str];
            if ((!number)||[number integerValue]<0) {
                [self showToast:@"请选择确认所有项目后点击维修完成！"];
                return;
            }
        }
    }
    
    //维修金额确认
    [self confirmRepairPrice:^{
        //提交请求
        [self doSubmitOrderRequest];
    }];
    
}

- (void)confirmRepairPrice:(XYAlertToolBlock)onConfirmed{
    
    if (self.viewModel.orderDetail.payStatus) {
        //如果已支付，则不需要弹框
        onConfirmed();
        return;
    }
    
    if (IS_IOS_8_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入本次维修金额" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField* field = [alertController textFields][0];
            [field resignFirstResponder];
            CGFloat inputValue = [[alertController textFields][0].text floatValue];
            if (ABS(inputValue - self.totalPrice) <= 0.01) {
                onConfirmed();
            }else{
                [self showToast:@"金额错误，请重新输入！"];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView* confirmAlertView = [[UIAlertView alloc]init];
        [confirmAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField* field = [confirmAlertView textFieldAtIndex:0];
        field.keyboardType = UIKeyboardTypeDecimalPad;
        [confirmAlertView setTitle:@"请输入本次维修金额"];
        confirmAlertView.didDismissBlock = ^(UIAlertView *alertView, NSInteger buttonIndex){
            UITextField* field = [alertView textFieldAtIndex:0];
            [field resignFirstResponder];
            CGFloat inputValue = [field.text floatValue];
            if (ABS(inputValue - self.totalPrice) <= 0.01) {
                onConfirmed();
            }else{
                [self showToast:@"金额错误，请重新输入！"];
            }
        };
    }
}

- (void)doSubmitOrderRequest{

    XYRepairSelections* selections = [[XYRepairSelections alloc]init];
    for (NSString* key in [self.resultMap allKeys]) {
        [selections setValue:[NSString stringWithFormat:@"%@",@([[self.resultMap objectForKey:key] integerValue]+1)] forKey:key];
    }
    
    [self showLoadingMask];
    __weak __typeof__(self) weakSelf = self;
    //维修完成 需要定位
    [[XYLocationManagerWithTimer sharedManager].locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        //维修完成
        [[XYAPIService shareInstance] completeOrder:self.viewModel.orderDetail.id bid:self.viewModel.orderDetail.bid withOtherFaults:self.viewModel.orderDetail.allowExtraPrice withOtherFaults_noRecyle:self.viewModel.orderDetail.allowExtraPrice_noRecyle is_fixed:[selections.is_fixed integerValue] is_miss:[selections.is_miss integerValue] is_wet:[selections.is_wet integerValue] is_deformed:[selections.is_deformed integerValue] is_recycle:[selections.is_recycle integerValue] is_used:[selections.is_used integerValue] is_normal:[selections.is_normal integerValue] address:regeocode.formattedAddress lat:[NSString stringWithFormat:@"%@",@(location.coordinate.latitude)] lng:[NSString stringWithFormat:@"%@",@(location.coordinate.longitude)] success:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_OLD_ORDER object:nil];
            [weakSelf.viewModel loadOrderDetail:weakSelf.viewModel.orderDetail.id bid:weakSelf.viewModel.orderDetail.bid];
            [weakSelf hideLoadingMask];
            [weakSelf showToast:@"维修完成！"];
            [weakSelf performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
            
            //如果为第三方支付
            if (weakSelf.viewModel.orderDetail.payment>XYPaymentTypeWorkerAlipay) {
                XYServiceProtocolView *protocolView = [XYServiceProtocolView protocolViewWithNotice:@"您完成了一个第三方平台订单，请引导用户对Hi维修进行好评!"];
                __weak typeof(protocolView) weakView = protocolView;
                [protocolView setButtonsDidClick:^{
                    [weakView dismiss];
                }];
                [protocolView show];
            }
        }errorString:^(NSString *error){
            [weakSelf hideLoadingMask];
            [weakSelf showToast:error];
        }];
    }];
    
    
}

#pragma mark - photos

- (IBAction)takeWechatPhoto:(id)sender {
    if(![XYStringUtil isNullOrEmpty:self.viewModel.orderDetail.weixin_promotion_img]){
        [self showBigImage:[NSURL URLWithString:self.viewModel.orderDetail.weixin_promotion_img] name:@"weixin_promotion_img"];
    }else{
        [self takePhoto:XYPictureTypeWechat];
    }
}

- (void)showBigImage:(NSURL*)imgUrl name:(NSString*)picName{
    [XYPhotoBigImageView showBigImageWithUrl:imgUrl name:picName canRetake:true delegate:self];
}

- (void)retakePicture:(NSString*)picName{
    [self takePhoto:XYPictureTypeWechat];
}

- (void)takePhoto:(XYPictureType)type{
    if (type == XYPictureTypeSelfPhotoTaking && self.viewModel.hasTakenSelfPhoto) {
        //自拍，已经拍过了
        return;
    }
    self.currentPictureTaken = type;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:false completion:nil];
    }else{
        [self showToast:@"设备不支持拍照"];
        return;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //压缩保存图片
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *rotatedOriginalImage = [XYWidgetUtil rotateImage:originalImage];
    NSData* data = [XYWidgetUtil resetSizeOfImageData:rotatedOriginalImage maxSize:90];
    TTDEBUGLOG(@"data:%@k",@(data.length/1024.0));
    if([self.viewModel getPhotoSavingAvailable]){
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){//现拍的，先保存到相册
            UIImage* finalImage = [UIImage imageWithData:data];
            UIImageWriteToSavedPhotosAlbum(finalImage, self, nil, NULL);
        }
    }
    [picker dismissViewControllerAnimated:false completion:nil];
    //上传图片
    [self.viewModel uploadAsynPhoto:data type:self.currentPictureTaken repeatCount:0 orderId:self.viewModel.orderDetail.id bid:self.viewModel.orderDetail.bid name:nil onSuccess:^(NSString *url) {
        switch (self.currentPictureTaken) {
            case XYPictureTypeWechat:
                self.viewModel.orderDetail.weixin_promotion_img = url;
                [self.photoImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.orderDetail.weixin_promotion_img] placeholder:[UIImage imageNamed:@"photo_add"]];
                break;
            case XYPictureTypeSelfPhotoTaking:
                TTDEBUGLOG(@"自拍照片：%@",url);
                break;
            default:
                break;
        }
    }onFailure:^{
        //提示上传失败
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //不允许取消拍摄
    self.tableView.hidden = true;
    [picker dismissViewControllerAnimated:false completion:^{
        [self.navigationController popViewControllerAnimated:false];
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
