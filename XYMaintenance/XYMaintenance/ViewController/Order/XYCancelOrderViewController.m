//
//  XYCancelOrderViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/3/31.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYCancelOrderViewController.h"
#import "XYGesturableScrollView.h"
#import "UIPlaceHolderTextView.h"
#import "XYCancelReasonCell.h"


@interface XYCancelOrderViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
//UI
@property(strong,nonatomic)XYGesturableScrollView* scrollView;
@property(nonatomic,strong)UITableView* userTableView;
@property(nonatomic,strong)UITableView* workerTableView;
@property(weak,nonatomic)IBOutlet UIPlaceHolderTextView* remarkView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *workerButton;
//DATA
@property(strong,nonatomic)NSMutableArray* userArray;
@property(strong,nonatomic)NSMutableArray* workerArray;
@property(copy,nonatomic)NSString* selectedId;//选定的原因id

@end

@implementation XYCancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getReasonSelections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];
     self.navigationItem.title = @"";
    [self customizeRemarkView];
}

#pragma mark - override

- (void)initializeData{
    self.selectedId = @"";
    self.userArray = [[NSMutableArray alloc]init];
    self.workerArray = [[NSMutableArray alloc]init];
}

- (void)initializeUIElements{
    //选择
    self.navigationItem.titleView = self.titleView;
    self.titleView.backgroundColor = THEME_COLOR;
    //主列表
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.userTableView];
    [self.scrollView addSubview:self.workerTableView];
    //默认点亮用户原因
    [self highLightButton:false];
}

#pragma mark - property

- (void)customizeRemarkView{
    //备注
    [self.remarkView _initialize];
    self.remarkView.placeholder = @"备注字数不超过150字";
    self.remarkView.maxInputNumber = 150;
    self.remarkView.font = [UIFont systemFontOfSize:15];
    self.remarkView.backgroundColor = [UIColor whiteColor];
    self.remarkView.layer.borderColor = XY_COLOR(204,204,204).CGColor;
    self.remarkView.layer.borderWidth = LINE_HEIGHT;
    self.remarkView.placeholderTextColor = XY_HEX(0xcccccc);
    self.remarkView.textColor = XY_HEX(0x333333);
}

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        CGFloat scrollableHeight = SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - 35 - 65 - 170;
        _scrollView = [[XYGesturableScrollView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, scrollableHeight)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, self.scrollView.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.bounces = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UITableView*)userTableView{
    if (!_userTableView) {
        _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.tag = 0;
        _userTableView.showsVerticalScrollIndicator = true;
        [_userTableView setTableFooterView:[[UIView alloc]init]];
        [XYCancelReasonCell xy_registerTableView:_userTableView identifier:[XYCancelReasonCell defaultReuseId]];
    }
    return _userTableView;
}

- (UITableView*)workerTableView{
    if (!_workerTableView) {
        _workerTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        _workerTableView.backgroundColor = [UIColor whiteColor];
        _workerTableView.tag = 1;
        _workerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _workerTableView.delegate = self;
        _workerTableView.dataSource = self;
        _workerTableView.showsVerticalScrollIndicator = true;
        [_workerTableView setTableFooterView:[[UIView alloc]init]];
        [XYCancelReasonCell xy_registerTableView:_workerTableView identifier:[XYCancelReasonCell defaultReuseId]];
    }
    return _workerTableView;
}


#pragma mark - scroll

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self highLightButton:(scrollView.contentOffset.x > 0)];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (tableView.tag == 0)?self.userArray.count:self.workerArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYCancelReasonCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYCancelReasonCell defaultReuseId]];
    
    XYReasonDto* dto;
    if (tableView.tag == 0) {
        dto = self.userArray[indexPath.row];
    }else if(tableView.tag == 1){
        dto = self.workerArray[indexPath.row];
    }
    
    cell.reasonLabel.text = XY_NOTNULL(dto.name,@"");
    [cell setXYSelected:[dto.Id isEqualToString:self.selectedId]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYReasonDto* dto;
    if (tableView.tag == 0) {
        dto = self.userArray[indexPath.row];
    }else if(tableView.tag == 1){
        dto = self.workerArray[indexPath.row];
    }
    self.selectedId = dto.Id;
    [self.userTableView reloadData];
    [self.workerTableView reloadData];
}


#pragma mark - action

- (void)highLightButton:(BOOL)isWorker{
    [self.workerButton setTitleColor:isWorker?WHITE_COLOR:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateNormal];
    self.workerButton.titleLabel.font = [UIFont systemFontOfSize:isWorker?18:16];
    [self.userButton setTitleColor:isWorker?[UIColor colorWithWhite:1 alpha:0.7]:WHITE_COLOR forState:UIControlStateNormal];
    self.userButton.titleLabel.font = [UIFont systemFontOfSize:isWorker?16:18];
}

- (void)getReasonSelections{
    [self showLoadingMask];
    __weak typeof(self) weakSelf = self;
    [[XYAPIService shareInstance]getCancelReason:^(NSArray<XYReasonDto *> *reasons) {
        [weakSelf hideLoadingMask];
        [self.userArray removeAllObjects];
        [self.workerArray removeAllObjects];
        for(XYReasonDto* reason in reasons){
            switch (reason.type) {
                case XYCancelReasonTypeUser:
                    [self.userArray addObject:reason];
                    break;
                case XYCancelReasonTypeWorker:
                    [self.workerArray addObject:reason];
                    break;
                case XYCancelReasonTypeOther:
                    [self.userArray addObject:reason];
                    [self.workerArray addObject:reason];
                    break;
                default:
                    break;
            }
        }
        [self.userTableView reloadData];
        [self.workerTableView reloadData];
    } errorString:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

- (IBAction)showUserReasons:(id)sender {
    [self highLightButton:false];
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)showWorkerReasons:(id)sender {
    [self highLightButton:true];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
}

- (IBAction)submit:(id)sender {
    
    if ( (!self.selectedId) || self.selectedId.length == 0) {
        [self showToast:@"请选择取消原因！"];
        return;
    }
    
    if ( (!self.remarkView.text) || self.remarkView.text.length == 0) {
        [self showToast:@"请输入备注！"];
        return;
    }
    
    [self showLoadingMask];
    __weak typeof(self) weakSelf = self;
    [[XYAPIService shareInstance]cancelOrder:self.orderId reason:self.selectedId remark:self.remarkView.text bid:self.bid success:^{
        [weakSelf hideLoadingMask];
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
        [weakSelf showToast:@"取消申请提交成功！"];
        [weakSelf performSelector:@selector(returnToRootList) withObject:nil afterDelay:1.0];
    } errorString:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

- (void)returnToRootList{
    [self.navigationController popToRootViewControllerAnimated:true];
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
