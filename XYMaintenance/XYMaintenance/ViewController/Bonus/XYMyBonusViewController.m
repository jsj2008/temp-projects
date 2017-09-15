//
//  XYMyBonusViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYMyBonusViewController.h"
#import "XYBonusListViewController.h"

@interface XYMyBonusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *monthBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBonusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderWidth;
@end

@implementation XYMyBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadBonusData];
}


- (void)initializeUIElements{
    self.navigationItem.title = @"提成";
    self.view.backgroundColor = XY_COLOR(237, 240, 243);
    self.deviderWidth.constant = LINE_HEIGHT;
}

- (void)loadBonusData{
    [self showLoadingMask];
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance] getBonusData:^(XYBonusDto *bonus) {
        [weakSelf hideLoadingMask];
        weakSelf.monthBonusLabel.text = [NSString stringWithFormat:@"%g",bonus.mouth_push_money];
        weakSelf.todayBonusLabel.text = [NSString stringWithFormat:@"%g",bonus.day_push_money];
        weakSelf.totalBonusLabel.text = [NSString stringWithFormat:@"%g",bonus.total_push_money];
    } errorString:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

- (IBAction)goTodayBonus:(id)sender {
    [self goToBonusList:true];
}

- (IBAction)goHistoryBonus:(id)sender {
    [self goToBonusList:false];
}

- (void)goToBonusList:(BOOL)isToday{
    XYBonusListViewController* listViewController = [[XYBonusListViewController alloc]initWithType:isToday];
    [self.navigationController pushViewController:listViewController animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
