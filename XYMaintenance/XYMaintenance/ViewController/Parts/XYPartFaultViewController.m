//
//  XYPartFaultViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartFaultViewController.h"
#import "SimpleAlignCell.h"
#import "XYPartColorViewController.h"

@interface XYPartFaultViewController ()<UITableViewDelegate,UITableViewDataSource,XYPartColorDelegate>

@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* brandId;
@property(assign,nonatomic)XYBrandType bid;
@property(strong,nonatomic)NSArray* faultsArray;

@property(assign,nonatomic) id<XYPartFaultDelegate> delegate;

@end

@implementation XYPartFaultViewController

- (id)initWithDevice:(NSString*)deviceId
               brand:(NSString*)brandId
                 bid:(XYBrandType)bid
            delegate:(id<XYPartFaultDelegate>)delegate{
    if (self = [super init]){
        _deviceId = [deviceId copy];
        _brandId = [brandId copy];
        _bid = bid;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAllFaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property

- (NSArray*)faultsArray{
    if (!_faultsArray) {
        _faultsArray = [[NSArray alloc]init];
    }
    return _faultsArray;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [_tableView setTableHeaderView:nil];
        [SimpleAlignCell xy_registerTableView:_tableView identifier:[SimpleAlignCell defaultReuseId]];
    }
    return _tableView;
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择故障";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

- (void)getAllFaults{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getAllFaultsType:XYOrderTypeNormal success:^(NSArray *faultArray) {
        weakself.faultsArray = faultArray;
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
    } errorString:^(NSString *err) {
        [weakself hideLoadingMask];
        [weakself showToast:err];
    }];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.faultsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    XYLabelDto* dto = [self.faultsArray objectAtIndex:indexPath.row];
    cell.xyTextLabel.text = dto.Name;
    cell.xyDetailLabel.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYLabelDto* dto = [self.faultsArray objectAtIndex:indexPath.row];
    XYPartColorViewController* colorViewController = [[XYPartColorViewController alloc]initWithDevice:self.deviceId brand:self.brandId fault:dto.Id bid:self.bid delegate:self];
    [self.navigationController pushViewController:colorViewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

-(void)onPartsSelected:(XYPartsSelectionDto *)partsSelection {
    if ([self.delegate respondsToSelector:@selector(onPartsSelected:)]) {
       [self.delegate onPartsSelected:partsSelection];
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
