//
//  XYInputCustomDeviceViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYInputCustomDeviceViewController.h"

@interface XYInputCustomDeviceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *productNameText;
@property (weak, nonatomic) IBOutlet UITextField *brandNameText;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameText;
@property (weak, nonatomic) IBOutlet UITextField *devicePriceText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight5;

@end

@implementation XYInputCustomDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUIElements{
    self.navigationItem.title = @"自定义机型";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    //pre data
    self.productNameText.text = XY_NOTNULL(self.preProductName, @"");
    self.brandNameText.text = XY_NOTNULL(self.preBrandName, @"");
    self.deviceNameText.text = XY_NOTNULL(self.preDeviceName, @"");
    self.devicePriceText.text = XY_NOTNULL(self.preDevicePrice, @"");
    
    self.dividerHeight1.constant = self.dividerHeight2.constant
      = self.deviderHeight3.constant = self.deviderHeight4.constant
         = self.deviderHeight5.constant = LINE_HEIGHT;
}

- (void)save{
    
    if ([XYStringUtil isNullOrEmpty:self.productNameText.text] || [XYStringUtil isNullOrEmpty:self.brandNameText.text]
        || [XYStringUtil isNullOrEmpty:self.deviceNameText.text] || [XYStringUtil isNullOrEmpty:self.devicePriceText.text]) {
        [self showToast:@"请填写完整后保存！"];
        return;
    }
    
    if ([self.devicePriceText.text integerValue]<=0) {
        [self showToast:@"价格必须为正数！"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(onCustomDeviceSaved:brand:device:price:)]) {
       [self.delegate onCustomDeviceSaved:self.productNameText.text brand:self.brandNameText.text device:self.deviceNameText.text price:[self.devicePriceText.text integerValue]];
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
