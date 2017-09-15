//
//  XYSettingViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYSettingViewController.h"
#import "XYAboutUsViewController.h"
#import "AppDelegate.h"

@interface XYSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* tableView;
@end

@implementation XYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    //title
    self.navigationItem.title = @"设置";
    //table
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
    self.tableView.backgroundColor = XY_COLOR(239,239,244);
    self.tableView.rowHeight = 50;
    self.tableView.separatorColor = XY_COLOR(211,215,223);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    self.tableView.tableHeaderView = [XYWidgetUtil getSingleLine];
    self.tableView.tableFooterView = [self getLogoutFooterView];
}


#pragma mark - action

//退出当前帐号
- (void)exitCurrentAccount{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲,确定退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

//退出弹框
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.viewModel logout];
        [self.navigationController popToRootViewControllerAnimated:false];
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate showLoginView];
    }
}

- (UIView*)getLogoutFooterView{
    UIButton* logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 71)];
    logoutButton.backgroundColor = XY_COLOR(238,240,243);
    logoutButton.titleLabel.font = SIMPLE_TEXT_FONT;
    [logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logoutButton setTitleColor:MOST_LIGHT_COLOR forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(exitCurrentAccount) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, logoutButton.bounds.size.height - 10, SCREEN_WIDTH,LINE_HEIGHT)];
    line.backgroundColor = DEVIDE_LINE_COLOR;
    [logoutButton addSubview:line];
    return logoutButton;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellReuseIdentifier = @"SettingControllerCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
       // cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
        cell.textLabel.font = SIMPLE_TEXT_FONT;
        cell.textLabel.textColor = BLACK_COLOR;
        cell.detailTextLabel.font = SMALL_TEXT_FONT;
        cell.detailTextLabel.textColor = MOST_LIGHT_COLOR;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"user_update"];
    cell.textLabel.text = @"关于我们";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本：%@",[XYAPPSingleton sharedInstance].appVersion];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYAboutUsViewController* aboutUsViewController = [[XYAboutUsViewController alloc]init];
    [self.navigationController pushViewController:aboutUsViewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
