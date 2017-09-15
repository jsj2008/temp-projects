//
//  XYAboutUsViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAboutUsViewController.h"
#import "XYAPPSingleton.h"

@interface XYAboutUsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation XYAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUIElements{
    self.navigationItem.title = @"关于我们";
    self.versionLabel.text = [XYAPPSingleton sharedInstance].appVersion;
    self.phoneLabel.text = [NSString stringWithFormat:@"官方热线：%@",SERVICE_PHONE];
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
