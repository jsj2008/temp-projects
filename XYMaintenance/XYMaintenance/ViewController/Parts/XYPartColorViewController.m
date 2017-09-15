//
//  XYPartColorViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartColorViewController.h"
#import "SimpleAlignCell.h"
#import "XYPartSelectionsViewController.h"

@interface XYPartColorViewController ()<UITableViewDataSource,UITableViewDelegate,XYPartSelectionsDelegate>

@property(strong,nonatomic) UITableView* tableView;
@property(strong,nonatomic) NSArray* colorArray;
@property(strong,nonatomic) XYColorDto* selectedColor;

@property(assign,nonatomic)id<XYPartColorDelegate> delegate;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* brandId;
@property(strong,nonatomic)NSString* faultId;
@property(assign,nonatomic)XYBrandType bid;
@end

@implementation XYPartColorViewController

- (instancetype)initWithDevice:(NSString*)deviceId
                         brand:(NSString*)brandId
                         fault:(NSString*)faultId
                           bid:(XYBrandType)bid
                      delegate:(id<XYPartColorDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        self.brandId = brandId;
        self.deviceId = deviceId;
        self.faultId = faultId;
        self.bid = bid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getColors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择颜色";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

#pragma mark - property

- (NSArray*)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSArray alloc]init];
    }
    return _colorArray;
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

- (void)getColors{
    
    [self showLoadingMask];
    self.tableView.hidden = true;
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getColorByDeviceId:self.deviceId fault:self.faultId bid:self.bid  success:^(NSArray *colors){
        weakself.colorArray = colors;
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
        weakself.tableView.hidden = false;
    }errorString:^(NSString *e){
        [weakself hideLoadingMask];
        [weakself showToast:e];
    }];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.colorArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    XYColorDto* dto = [self.colorArray objectAtIndex:indexPath.row];
    cell.xyTextLabel.text = [NSString stringWithFormat:@" %@",dto.ColorName];
    cell.xyDetailLabel.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.selectedColor = [self.colorArray objectAtIndex:indexPath.row];
    XYPartSelectionsViewController* selectionsViewController = [[XYPartSelectionsViewController alloc]initWithDevice:self.deviceId fault:self.faultId color:self.selectedColor.ColorId delegate:self];
    [self.navigationController pushViewController:selectionsViewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - delegate
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
